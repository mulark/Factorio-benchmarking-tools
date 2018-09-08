/c     
local surface=game.player.surface
local tile_paste_length = 64
local start_tile=0
local times_to_paste=1
local start_tick=game.tick
local entity_pool = surface.find_entities_filtered({area={{-1000, (start_tile-tile_paste_length)}, {1000, start_tile}}, force="player"})
local first_run = true
local ticks_per_paste = 2

local function has_value (val, tab)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

if ((tile_paste_length % 2) ~= 0) then
    tile_paste_length = tile_paste_length + 1
end

script.on_event(defines.events.on_tick, function(event)
    if (first_run == true) then
        if(game.tick == start_tick) then
            for key, ent in pairs(surface.find_entities_filtered({area={{-1000, (start_tile-(tile_paste_length*(times_to_paste+1)))}, {1000, (start_tile-tile_paste_length)}}, force="player"})) do
                if (ent.type ~= "player") then
                    ent.destroy()
                end
            end
            game.forces.player.chart(surface, {{x = -500, y = (start_tile-(tile_paste_length*(times_to_paste+1)))}, {x = 500, y = (start_tile-tile_paste_length)}})
        end
        for current_paste = 1, times_to_paste do
                if (game.tick == (start_tick + (current_paste * ticks_per_paste))) then
                        for key, ent in pairs(entity_pool) do
                            if not has_value(ent.type, {"beacon", "locomotive", "player", "cargo-wagon", "logistic-robot", "construction-robot"}) then
                                if (ent.type == "underground-belt") then
                                    surface.create_entity{name = ent.name, position={ent.position.x+0, ent.position.y-(tile_paste_length*current_paste)}, direction=ent.direction, force="player", type=ent.belt_to_ground_type}
                                else
                                    surface.create_entity{name = ent.name, position={ent.position.x+0, ent.position.y-(tile_paste_length*current_paste)}, direction=ent.direction, force="player"}
                                end
                                local newent = surface.find_entity(ent.name, {ent.position.x+0, ent.position.y-(tile_paste_length*current_paste)})
                                if (newent.type == "loader") then
                                    newent.loader_type = ent.loader_type
                                    newent.direction = ent.direction
                                end
                                newent.copy_settings(ent)
                                newent.orientation = ent.orientation
                                if (ent.get_module_inventory()) then
                                    for x=1,#ent.get_module_inventory() do
                                        if (ent.get_module_inventory()[x].valid_for_read) then
                                            newent.insert(ent.get_module_inventory()[x])
                                        end
                                    end
                                end
                                if (newent.type == "mining-drill") then
                                    local resource_patch = surface.find_entities_filtered({type = "resource", position={ent.position.x, ent.position.y}})
                                    for key, resource_to_clear in pairs(surface.find_entities_filtered({type = "resource", position={newent.position.x, newent.position.y}})) do
                                        resource_to_clear.destroy()
                                    end
                                    surface.create_entity({name = resource_patch[1].name, position = {newent.position.x, newent.position.y}, force = "neutral", amount = resource_patch[1].amount})
                                end  
                                if (newent.get_fuel_inventory()) then
                                    if (newent.get_fuel_inventory().is_empty()) then
                                        newent.get_fuel_inventory().insert("nuclear-fuel")
                                    end
                                end
                                if (ent.get_inventory(defines.inventory.chest)) then
                                    local chest_inventory = ent.get_inventory(defines.inventory.chest)
                                    for k=1,#chest_inventory do
                                        if (chest_inventory[k].valid_for_read) then
                                            local itemname = chest_inventory[k].name
                                            local itemamount = chest_inventory[k].count
                                            if (itemamount > 1) then
                                                if not (newent.type == "roboport") then
                                                    itemamount = itemamount - 1
                                                end
                                            end
                                            newent.insert({name=itemname, count=itemamount})
                                        end
                                    end
                                end
                                if (ent.get_inventory(defines.inventory.car_trunk)) then
                                    for k=1,#ent.get_inventory(defines.inventory.car_trunk) do
                                        if (ent.get_inventory(defines.inventory.car_trunk)[k].valid_for_read) then
                                            local inventory = ent.get_inventory(defines.inventory.car_trunk)
                                            local itemname = inventory[k].name
                                            local itemamount = inventory[k].count
                                            if (itemamount > 1) then
                                                itemamount = itemamount - 1
                                            end
                                            newent.insert({name=itemname, count=itemamount})
                                        end
                                    end
                                end
                                if (ent.circuit_connection_definitions) then
                                    for x=1, #ent.circuit_connection_definitions do
                                        local targetent = ent.circuit_connection_definitions[x].target_entity
                                        offset_x = (ent.position.x - targetent.position.x)
                                        offset_y = (ent.position.y - targetent.position.y)
                                        if (surface.find_entity(targetent.name, {(newent.position.x - offset_x), (newent.position.y - offset_y)})) then
                                            local targetnewent = surface.find_entity(targetent.name, {(newent.position.x - offset_x), (newent.position.y - offset_y)})
                                            newent.connect_neighbour({target_entity = targetnewent, wire=ent.circuit_connection_definitions[x].wire, source_circuit_id=ent.circuit_connection_definitions[x].source_circuit_id, target_circuit_id=ent.circuit_connection_definitions[x].target_circuit_id})
                                        end
                                    end
                                end
                                
                                
                                
                            end
                        end
                end
               
                if (game.tick == (start_tick + ((current_paste + 1) * ticks_per_paste))) then
                        for key, ent in pairs(entity_pool) do
                            if has_value(ent.type, {"beacon", "locomotive", "cargo-wagon", "logistic-robot", "construction-robot"}) then
                                surface.create_entity{name=ent.name, position={ent.position.x+0, ent.position.y-(tile_paste_length*(current_paste))}, direction=ent.direction, force="player"}
                                local newent = surface.find_entity(ent.name, {ent.position.x+0, ent.position.y-(tile_paste_length*(current_paste))})
                                if (ent.train) then
                                    newent.disconnect_rolling_stock(defines.rail_direction.front)
                                    newent.disconnect_rolling_stock(defines.rail_direction.back)
                                    newent.train.manual_mode = ent.train.manual_mode
                                    newent.train.schedule = ent.train.schedule
                                    if (ent.orientation <= 0.5) then
                                        if (ent.orientation ~= 0) then
                                            newent.rotate()
                                        end
                                    end
                                    newent.connect_rolling_stock(defines.rail_direction.front)
                                    newent.connect_rolling_stock(defines.rail_direction.back)
                                    newent.copy_settings(ent)
                                    if (newent.get_fuel_inventory()) then
                                        if (newent.get_fuel_inventory().is_empty()) then
                                            newent.get_fuel_inventory().insert("nuclear-fuel")
                                        end
                                    end
                                    if (ent.get_inventory(defines.inventory.chest)) then
                                        for k=1,#ent.get_inventory(defines.inventory.chest) do
                                            if (ent.get_inventory(defines.inventory.chest)[k].valid_for_read) then
                                                local inventory = ent.get_inventory(defines.inventory.chest)
                                                local itemname = inventory[k].name
                                                local itemamount = inventory[k].count
                                                if (itemamount > 1) then
                                                    itemamount = itemamount - 1
                                                end
                                            newent.insert({name=itemname, count=itemamount})
                                            end
                                        end
                                    end
                                end
                                if (ent.get_module_inventory()) then
                                    for x=1,#ent.get_module_inventory() do
                                        if (ent.get_module_inventory()[x].valid_for_read) then
                                            newent.insert(ent.get_module_inventory()[x])
                                        end
                                    end
                                end
                                newent.update_connections()
                                
                            end
                        end
                end
        end
                  if (game.tick == (start_tick + (times_to_paste*ticks_per_paste) + 60 )) then
                    game.players[1].force.chart_all()
                    first_run = false
               end
    end
end);
