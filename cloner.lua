/c
local surface=game.player.surface
local tile_paste_length = 64
local start_tile = 0
local times_to_paste = 1
local start_tick = (game.tick + 1)
local entity_pool = surface.find_entities_filtered({area={{-1000, (start_tile-tile_paste_length)}, {1500, start_tile}}, force="player"})
local first_run = true
local ticks_per_paste = 2
local try_to_prime_inserters_pulling_from_belt = false
local low_priority_entities = {"beacon", "locomotive", "cargo-wagon", "logistic-robot", "construction-robot", "fluid-wagon"}
local use_exact_power_wires = false

if ((tile_paste_length % 2) ~= 0) then
    tile_paste_length = tile_paste_length + 1
end

local function has_value (val, tab)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local function clean_paste_area (surface, left, top, right, bottom)
    local second_try_destroy_entities = {}
    for key, ent in pairs(surface.find_entities_filtered({area={{left, top},{right, bottom}}, force="player"})) do
        if (ent.type ~= "player") then
            ent.clear_items_inside()
            if not (ent.can_be_destroyed()) then
                table.insert(second_try_destroy_entities, ent)
            end
            ent.destroy()
        end
    end
    for key, ent in pairs(second_try_destroy_entities) do
        ent.destroy()
    end
end

function copy_entity (original_entity, cloned_entity)
    copy_properties(original_entity, cloned_entity)
    copy_inventories(original_entity, cloned_entity)
    copy_resources(original_entity, cloned_entity)
    copy_circuit_connections(original_entity, cloned_entity)
    if (use_exact_power_wires) then
        copy_exact_power(original_entity, cloned_entity)
    end
    copy_train(original_entity, cloned_entity)
    cloned_entity.update_connections()
end

function copy_properties(original_entity, cloned_entity)
    if (original_entity.type == "loader") then
        cloned_entity.loader_type = original_entity.loader_type
    end
    cloned_entity.copy_settings(original_entity)
    cloned_entity.orientation = original_entity.orientation
    cloned_entity.direction = original_entity.direction
    if has_value(original_entity.type, {"rocket-silo", "assembling-machine"}) then
        cloned_entity.crafting_progress = original_entity.crafting_progress
    end
    if has_value(original_entity.type, {"rocket-silo"}) then
        cloned_entity.crafting_progress = original_entity.crafting_progress
        cloned_entity.rocket_parts = original_entity.rocket_parts
    end
    if (original_entity.burner) then
        if (original_entity.burner.currently_burning) then
            cloned_entity.burner.currently_burning = original_entity.burner.currently_burning
            cloned_entity.burner.remaining_burning_fuel = original_entity.burner.remaining_burning_fuel
        end
    end
end

function copy_inventories(original_entity, cloned_entity)
    local INV_DEFINE
    INV_DEFINE = defines.inventory.chest
    if (original_entity.get_inventory(INV_DEFINE)) then
        local working_inventory = original_entity.get_inventory(INV_DEFINE)
        for k=1,#working_inventory do
            if (working_inventory[k].valid_for_read) then
                cloned_entity.insert(working_inventory[k])
            end
        end
    end
    INV_DEFINE = defines.inventory.rocket_silo_result
    if (original_entity.get_inventory(INV_DEFINE)) then
        local working_inventory = original_entity.get_inventory(INV_DEFINE)
        for k=1,#working_inventory do
            if (working_inventory[k].valid_for_read) then
                cloned_entity.insert(working_inventory[k])
            end
        end
    end
    INV_DEFINE = defines.inventory.furnace_source
    if (original_entity.get_inventory(INV_DEFINE)) then
        local working_inventory = original_entity.get_inventory(INV_DEFINE)
        for k=1,#working_inventory do
            if (working_inventory[k].valid_for_read) then
                cloned_entity.insert(working_inventory[k])
            end
        end
    end
    if (original_entity.get_module_inventory()) then
        local working_inventory = original_entity.get_module_inventory()
        for k=1,#working_inventory do
            if (working_inventory[k].valid_for_read) then
                cloned_entity.insert(working_inventory[k])
            end
        end
    end
    if (original_entity.get_fuel_inventory()) then
        local working_inventory = original_entity.get_fuel_inventory()
        for k=1,#working_inventory do
            if (working_inventory[k].valid_for_read) then
                cloned_entity.insert(working_inventory[k])
            end
        end
    end
    if (#original_entity.fluidbox >= 1) then
        for x=1, #original_entity.fluidbox do
            cloned_entity.fluidbox[x] = original_entity.fluidbox[x]
        end
    end
end

function copy_resources(original_entity, cloned_entity)
    if (original_entity.type == "mining-drill") then
        if (original_entity.mining_target) then
            local resource = original_entity.mining_target
            for key, resource_to_clear in pairs(surface.find_entities_filtered({type = "resource", position={cloned_entity.position.x, cloned_entity.position.y}})) do
                resource_to_clear.destroy()
            end
            surface.create_entity({name = resource.name, position = cloned_entity.position, force = "neutral", amount = resource.amount})
            if (resource.initial_amount) then
                local newresource = surface.find_entity(resource.name, cloned_entity.position)
                newresource.initial_amount = resource.initial_amount
            end
        end
    end
end

function copy_circuit_connections (original_entity, cloned_entity)
    if (original_entity.circuit_connection_definitions) then
        for x=1, #original_entity.circuit_connection_definitions do
            local targetent = original_entity.circuit_connection_definitions[x].target_entity
            local offset_x = (original_entity.position.x - targetent.position.x)
            local offset_y = (original_entity.position.y - targetent.position.y)
            if (surface.find_entity(targetent.name, {(cloned_entity.position.x - offset_x), (cloned_entity.position.y - offset_y)})) then
                local targetnewent = surface.find_entity(targetent.name, {(cloned_entity.position.x - offset_x), (cloned_entity.position.y - offset_y)})
                cloned_entity.connect_neighbour({target_entity = targetnewent, wire=original_entity.circuit_connection_definitions[x].wire, source_circuit_id=original_entity.circuit_connection_definitions[x].source_circuit_id, target_circuit_id=original_entity.circuit_connection_definitions[x].target_circuit_id})
            end
        end
    end
end

function copy_exact_power (original_entity, cloned_entity)
    if (original_entity.type == "electric-pole") then
        cloned_entity.disconnect_neighbour()
        for x=1, #cloned_entity.neighbours["copper"] do
            local targetent = original_entity.neighbours["copper"][x]
            local offset_x = (original_entity.position.x - targetent.position.x)
            local offset_y = (original_entity.position.y - targetent.position.y)
            if (surface.find_entity(targetent.name, {(cloned_entity.position.x - offset_x), (cloned_entity.position.y - offset_y)})) then
                local targetnewent = surface.find_entity(targetent.name, {(cloned_entity.position.x - offset_x), (cloned_entity.position.y - offset_y)})
                cloned_entity.connect_neighbour(targetnewent)
            end
        end
    end
end

function copy_train(original_entity, cloned_entity)
    if (original_entity.train) then
        cloned_entity.disconnect_rolling_stock(defines.rail_direction.front)
        cloned_entity.disconnect_rolling_stock(defines.rail_direction.back)
        cloned_entity.train.schedule = original_entity.train.schedule
        if (original_entity.orientation <= 0.5) then
            if (original_entity.orientation ~= 0) then
                cloned_entity.rotate()
            end
        end
        cloned_entity.connect_rolling_stock(defines.rail_direction.front)
        cloned_entity.connect_rolling_stock(defines.rail_direction.back)
        cloned_entity.copy_settings(original_entity)
        cloned_entity.train.manual_mode = original_entity.train.manual_mode
    end
end

function clean_entity_pool(entity_pool)
    for key, ent in pairs(entity_pool) do
        if has_value(ent.type,{"player", "entity-ghost", "tile-ghost"}) then
            entity_pool[key] = nil
        end
        ent.active = false
    end
end

function prime_inserters(surface)
    for key, ent in pairs (surface.find_entities_filtered({force="player"})) do
        if has_value(ent.name, {"stack-inserter", "stack-filter-inserter"}) then
            if has_value(ent.pickup_target.type, {"underground-belt", "transport-belt"}) then
                if has_value(ent.drop_target.type, {"container", "car"}) then
                    local drop_target_inventory
                    local cleanly_primed_1 = false
                    local cleanly_primed_2 = false
                    if (ent.drop_target.type == "container") then
                        drop_target_inventory = ent.drop_target.get_inventory(defines.inventory.chest)
                    end
                    if (ent.drop_target.type == "car") then
                        drop_target_inventory = ent.drop_target.get_inventory(defines.inventory.car_trunk)
                    end
                    for item_name, unused in pairs (ent.pickup_target.get_transport_line(1).get_contents()) do
                        local amount_inside = drop_target_inventory.get_item_count(item_name)
                        local stack_size = game.item_prototypes[item_name].stack_size
                        local held_amount = 0
                        if (ent.held_stack.valid_for_read) then
                            if (ent.held_stack.name == item_name) then
                                held_amount = held_amount + ent.held_stack.count
                            end
                        end
                        if (((amount_inside + held_amount) % stack_size) ~= 0) then
                            ent.clear_items_inside()
                            drop_target_inventory.insert({name = item_name, amount = stack_size})
                            cleanly_primed_1 = true
                        end
                    end
                    for item_name, unused in pairs (ent.pickup_target.get_transport_line(2).get_contents()) do
                        local amount_inside = drop_target_inventory.get_item_count(item_name)
                        local stack_size = game.item_prototypes[item_name].stack_size
                        local held_amount = 0
                        if (ent.held_stack.valid_for_read) then
                            if (ent.held_stack.name == item_name) then
                                held_amount = held_amount + ent.held_stack.count
                            end
                        end
                        if (((amount_inside + held_amount) % stack_size) == 0) then
                            drop_target_inventory.remove({name = item_name, amount = 1})
                            cleanly_primed_2 = true
                        end
                    end
                    if not (cleanly_primed_1 and cleanly_primed_2) then
                        for item_name, item_amount in pairs (drop_target_inventory.get_contents()) do
                            drop_target_inventory.remove({name = item_name, amount = 1})
                        end
                    end
                end
            end
        end
    end
end



script.on_event(defines.events.on_tick, function(event)
    if (first_run == true) then
        for current_paste = 1, times_to_paste do
            if (game.tick == start_tick) then
                game.players[1].clear_console()
                clean_entity_pool(entity_pool)
                clean_paste_area(surface, -1000, (start_tile-(tile_paste_length*(times_to_paste+1))), 1000, (start_tile-tile_paste_length))
            end
            if (game.tick == (start_tick + (current_paste * ticks_per_paste))) then
                for key, ent in pairs(entity_pool) do
                    local x_offset = ent.position.x + 0
                    local y_offset = ent.position.y -(tile_paste_length*current_paste)
                    local create_entity_values = {name = ent.name, position={x_offset, y_offset}, direction=ent.direction, force="player"}
                    if not has_value(ent.type, low_priority_entities) then
                        if (ent.type == "underground-belt") then
                            create_entity_values.type = ent.belt_to_ground_type
                        end
                        surface.create_entity(create_entity_values)
                        local newent = surface.find_entity(ent.name, {x_offset, y_offset})
                        copy_entity(ent, newent)
                    end
                end
            end
            if (game.tick == (start_tick + (current_paste * ticks_per_paste) + 1)) then
                    for key, ent in pairs(entity_pool) do
                        local x_offset = ent.position.x + 0
                        local y_offset = ent.position.y -(tile_paste_length*current_paste)
                        local create_entity_values = {name = ent.name, position={x_offset, y_offset}, direction=ent.direction, force="player"}
                        if has_value(ent.type, low_priority_entities) then
                            surface.create_entity(create_entity_values)
                            local newent = surface.find_entity(ent.name, {x_offset, y_offset})
                            copy_entity(ent, newent)
                        end
                    end
            end
            if (game.tick == (start_tick + ((times_to_paste + 1)*ticks_per_paste) + 600 )) then
                for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
                    ent.active = true
                end
                game.players[1].force.chart_all()
                first_run = false
                if (try_to_prime_inserters_pulling_from_belt == true) then
                    prime_inserters(surface)
                end
            end
        end
   end
end);
