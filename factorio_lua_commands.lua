/c game.player.selected.connect_neighbour({target_entity = (game.player.surface.find_entity(game.player.selected.name, {(game.player.selected.position.x+5), game.player.selected.position.y})), wire=defines.wire_type.red})


/c game.player.selected.insert({name="iron-plate", count=99})


/c
game.player.force.technologies['mining-productivity-16'].researched=false;
local times=1840
for x=1, times do game.player.force.technologies['mining-productivity-16'].researched=true
end
/c
game.player.force.technologies['worker-robots-speed-6'].researched=false;
local times=20
for x=1, times do game.player.force.technologies['worker-robots-speed-6'].researched=true
end


/c
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
    if (ent.type ~="player") then
        ent.destroy()
    end
end

/c game.player.surface.delete_chunk({math.floor(game.player.selected.position.x / 32), math.floor(game.player.selected.position.y / 32)})


/c
local surface=game.player.surface
local tile_paste_length = 64
local start_tile=0
local times_to_paste=76
local start_tick=game.tick
local start_tick_plus=start_tick+60
local start_tick_plus_plus=start_tick+120
for key, ent in pairs(surface.find_entities_filtered({area={{-1000, (start_tile-(tile_paste_length*(times_to_paste+1)))}, {1000, (start_tile-tile_paste_length)}}, force="player"})) do

                ent.destroy()

end

/c local entity="steel"
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
	if string.find(ent.name,entity) then
        local chestinv = ent.get_inventory(defines.inventory.chest)
        chestinv.clear()
        chestinv.insert("concrete")
        chestinv.insert("concrete")
        chestinv.insert("concrete")
        game.player.print(ent.name)
	end
end;

/c local entity="splitter"
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
	if string.find(ent.name,entity) then
        ent.splitter_output_priority = "left"
        game.player.print(ent.name)
	end
end;



/c game.forces.player.chart(game.player.surface, {{x = -200, y = -10000}, {x = 600, y = 0}})


/c local entity="steel"
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
	if string.find(ent.name,entity) then
        local chestinv = ent.get_inventory(defines.inventory.chest)
        chestinv.clear()
        chestinv.insert("space-science-pack")
        chestinv.insert("science-pack-1")
        chestinv.insert("science-pack-2")
        chestinv.insert("science-pack-3")
        chestinv.insert("production-science-pack")
        chestinv.insert("high-tech-science-pack")
        game.player.print(ent.name)
	end
end;
local entity="car"
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
	if string.find(ent.name,entity) then
        local chestinv = ent.get_inventory(defines.inventory.car_trunk)
        chestinv.clear()
        chestinv.insert("science-pack-1")
        chestinv.insert("science-pack-2")
        chestinv.insert("science-pack-3")
        chestinv.insert("production-science-pack")
        chestinv.insert("high-tech-science-pack")
        chestinv.insert("space-science-pack")
        game.player.print(ent.name)
	end
end;
local entity="inserter"
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
	if string.find(ent.name,entity) then
        ent.clear_items_inside()
	end
end
/c local entity="loader"
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
	if string.find(ent.name,entity) then
        ent.rotate()
	end
end

/c local entity="inserter"
local surface=game.player.surface
local correct_count = 0
local incorrect_count = 0
for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
	if string.find(ent.name,entity) then
        if (ent.pickup_target.type == "underground-belt") then
            if (ent.held_stack.valid_for_read) then
                correct_count = correct_count + 1
            else
                incorrect_count = incorrect_count + 1
                game.player.teleport({ent.position.x, ent.position.y})
            end
        end
	end
end
game.player.print("correct_count: " .. correct_count .. " incorrect_count: " .. incorrect_count)


/c local entity="inserter"
local surface=game.player.surface
local correct_count = 0
local incorrect_count = 0
local function has_value (val, tab)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
	if string.find(ent.name,entity) then
        if has_value(ent.pickup_target.type, {"underground-belt", "belt"}) then
            if (ent.held_stack.valid_for_read) then
                correct_count = correct_count + 1
            else
                if has_value(ent.drop_target.type, {"car", "container"}) then
                    incorrect_count = (incorrect_count + 1)
                    game.player.teleport({ent.position.x, ent.position.y})
                    local collect_from = ent.drop_target.get_inventory(defines.inventory.chest)
                    for x=1, #collect_from do
                        if (collect_from[x].valid_for_read) then
                            if (collect_from[x].count > 1) then
                                collect_from.remove({name = collect_from[x].name, count = 1})
                            end
                        end
                    end
                end
            end
        end
	end
end
game.player.print("correct_count: " .. correct_count .. " incorrect_count: " .. incorrect_count)


/c
for item_name, item_amount in pairs (game.player.selected.pickup_target.get_transport_line(2).get_contents()) do
    game.player.print(item_name .. " " .. item_amount)
end



/c local entity="requester"
local surface=game.player.surface
local correct_count = 0
local incorrect_count = 0
for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
	if string.find(ent.name,entity) then
            local newinventory = ent.get_inventory(defines.inventory.chest)
            if (newinventory[2].valid_for_read) then
                newinventory.remove({name = newinventory[2].name, count = 1})
            end
	end
end


/c local entity="requester"
local surface=game.player.surface
local correct_count = 0
local incorrect_count = 0
for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
	if string.find(ent.name,entity) then
            surface.create_entity({name = "steel-chest", position = {ent.position.x, ent.position.y}, force="player", fast_replace = true})
	end
end


/c local entity="requester"
local surface=game.player.surface
local count = 0
local average_x = 0
local average_y = 0
local distance = 0
local max_distance = 0
local average_distance = 0
local passive_count = 0
local passive_average_x = 0
local passive_average_y = 0
for key, ent in pairs(surface.find_entities_filtered({force="player", name="logistic-chest-passive-provider"})) do
    passive_average_x = ent.position.x + passive_average_x
    passive_average_y = ent.position.y + passive_average_y
    passive_count = passive_count + 1
end
passive_average_x = passive_average_x / passive_count
passive_average_y = passive_average_y / passive_count
for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
	if string.find(ent.name,entity) then
            average_x = ent.position.x + average_x
            average_y = ent.position.y + average_y
            distance = math.sqrt((ent.position.x - passive_average_x)^2 + (ent.position.y - passive_average_y)^2)
            average_distance = average_distance + distance
            if (distance > max_distance) then
                max_distance = distance
                furthest_ent_x = ent.position.x
                furthest_ent_y = ent.position.y
            end
            count = count + 1
	end
end
average_x = average_x / count
average_y = average_y / count
average_distance = average_distance / count
game.player.print("Average of " .. passive_count .. " passive providers was x: " .. passive_average_x .. " y: " .. passive_average_y)
game.player.print("The average of " .. count .. " requesters was x: " .. average_x .. " Y: " .. average_y)
game.player.print("The farthest entity was at x: " .. furthest_ent_x .. " , y: " .. furthest_ent_y .. " distance: " .. max_distance)
game.player.print("Average distance: " .. average_distance)
game.player.teleport({furthest_ent_x, furthest_ent_y})




/c local entity="car"
local surface=game.player.surface
local count=0
for key, ent in pairs(surface.find_entities_filtered({force=game.player.force})) do
	if string.find(ent.name,entity) then
        local times=80
        for x=1,times do
            ent.get_inventory(2).set_filter(x, "raw-fish")
        end
        ent.get_inventory(2).set_filter(1, "copper-cable")
        ent.get_inventory(2).set_filter(2, "iron-plate")
	end
end


/c game.player.surface.create_entity{name="car", position={game.player.selected.position.x+0, game.player.selected.position.y+32}, direction=defines.direction.east, force=game.player.selected.force}

/c
local surface=game.player.surface
for key, ent in pairs (surface.find_entities_filtered{force="player"}) do
    if (ent.position.x > 256) then
        ent.destroy()
    end
end






/c local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player", type= "container", area={{-1000, -928.5}, {1000, -928.5}}})) do
        ent.clear_items_inside()
        ent.insert("copper-plate")
end
for key, ent in pairs(surface.find_entities_filtered({name = "stack-inserter", force="player", area={{-1000, -927.5}, {1000, -927.5}}})) do
        ent.clear_items_inside()
end
for key, ent in pairs(surface.find_entities_filtered({force="player", type= "container", area={{-1000, -28.5}, {1000, -28.5}}})) do
        ent.clear_items_inside()
        ent.insert("copper-plate")
end
for key, ent in pairs(surface.find_entities_filtered({name = "stack-inserter", force="player", area={{-1000, -27.5}, {1000, -27.5}}})) do
        ent.clear_items_inside()
end
for key, ent in pairs(surface.find_entities_filtered({force="player", type= "container", area={{-1000, -1828.5}, {1000, -1828.5}}})) do
        ent.clear_items_inside()
        ent.insert("copper-plate")
end
for key, ent in pairs(surface.find_entities_filtered({name = "stack-inserter", force="player", area={{-1000, -1827.5}, {1000, -1827.5}}})) do
        ent.clear_items_inside()
end
for key, ent in pairs(surface.find_entities_filtered({force="player", type= "container", area={{-1000, -2728.5}, {1000, -2728.5}}})) do
        ent.clear_items_inside()
        ent.insert("copper-plate")
end
for key, ent in pairs(surface.find_entities_filtered({name = "stack-inserter", force="player", area={{-1000, -2727.5}, {1000, -2727.5}}})) do
        ent.clear_items_inside()
end
for key, ent in pairs(surface.find_entities_filtered({force="player", type= "container", area={{-1000, -3628.5}, {1000, -3628.5}}})) do
        ent.clear_items_inside()
        ent.insert("copper-plate")
end
for key, ent in pairs(surface.find_entities_filtered({name = "stack-inserter", force="player", area={{-1000, -3627.5}, {1000, -3627.5}}})) do
        ent.clear_items_inside()
end


/c local surface=game.player.surface
for key, ent in pairs(game.player.selected.circuit_connected_entities) do
        game.player.print(ent.name)
end



/c
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player", name="steel-chest"})) do
    surface.create_entity({name="wooden-chest", fast_replace=true, position=ent.position, force = "player", spill=false})
end
/c
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player", name="wooden-chest"})) do
    ent.get_inventory(defines.inventory.chest).setbar()
end
/c
local surface = game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player", name="steel-chest"})) do
    ent.get_inventory(defines.inventory.chest).setbar()
end
/c
local surface = game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player", name="steel-chest"})) do
    ent.get_inventory(defines.inventory.chest).setbar(17)
end

/c
for x=0,0 do
    game.player.print("foo")
end

/c
for x=0, 3 do
    game.player.selected.get_transport_line(1).insert_at(x/4,{name="iron-ore"})
end

/c
local original_entity = game.player.selected
for item_name, item_amount in pairs(original_entity.get_transport_line(1).get_contents()) do
    game.player.print(item_name .. "," .. item_amount)
end


/c local visiblity = "infinity"
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player", type="infinity-container"})) do
    if (ent.remove_unfiltered_items == true) then
        ent.remove_unfiltered_items = false
    else
        ent.remove_unfiltered_items = true
    end
end


/c local surface=game.player.surface
for _, ent in pairs(game.player.surface.find_entities_filtered{type="item-entity", name="item-on-ground"}) do
    ent.destroy()
end



/c local surface=game.player.surface
for _, ent in pairs(game.player.surface.find_entities_filtered{force="player"}) do

    ent.disconnect_neighbour(defines.wire_type.green)
end




/c local entity="infinity"
local surface=game.player.surface
local count=0
for key, ent in pairs(surface.find_entities_filtered({force=game.player.force})) do
	if string.find(ent.name,entity) then
		count=count+1
	end
end
game.player.print(count)


/c local entity="lab"
local surface=game.player.surface
local count=0
for key, ent in pairs(surface.find_entities_filtered({name = entity, force=game.player.force})) do
    for x=1, #ent.get_inventory(defines.inventory.lab_input) do
        if (ent.get_inventory(defines.inventory.lab_input)[x].valid_for_read) then
            count = count + 1
            ent.get_inventory(defines.inventory.lab_input)[x].durability = ((count % 1000) + 1)/1000
        end
    end
end





/c local entity="express-transport-belt"
local surface=game.player.surface
local count=0
for key, ent in pairs(surface.find_entities_filtered({name = entity, force=game.player.force})) do
    count=count+1
end
game.player.print(count)


/c local class="item-entity"
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({type = class})) do
    ent.destroy()
end


/c local class="entity-ghost"
local count = 0
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({type = class, force = "player"})) do
        game.player.print("X: " .. ent.position.x .. "Y: " .. ent.position.y)
        game.player.teleport({ent.position.x, ent.position.y})
        count = count + 1
end
game.player.print(count)

/c local class="damaged-entity"
local count = 0
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force = "player"})) do
    if (ent.health) then
        if (ent.health ~= ent.prototype.max_health) then
        game.player.print("X: " .. ent.position.x .. "Y: " .. ent.position.y)
        count = count + 1
        end
    end
end
game.player.print(count)


/c game.forces.player.chart(game.player.surface, {{x = 0, y = -3000}, {x = 1000, y = 0}})


/c local entity="requester"
local surface=game.player.surface
local count=0
for key, ent in pairs(surface.find_entities_filtered({force=game.player.force})) do
	if string.find(ent.name,entity) then
		count=count+1
        ent.clear_items_inside()
        for x=1, ent.request_slot_count do
            if( ent.get_request_slot(x)) then
                ent.insert(ent.get_request_slot(x))
            end
        end
	end
end
game.player.print(count)




/c local entity="lab"
local surface=game.player.surface
local count=0
for key, ent in pairs(surface.find_entities_filtered({name = entity, force=game.player.force})) do
		count=count+1

end
game.player.print(count)





/c
local count = 0
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force = "neutral", type = "tree"})) do
    ent.destroy()
    count=count + 1
end
game.player.print(count)



/c
local count = 0
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force = "player", type = "mining-drill"})) do
    count=count + 1
end
game.player.print(count * 27.9)

/c local surface = game.player.surface
for x=0, 32 do
    for y=0, 32 do
        surface.create_entity({name = "tree-04", position = {x, y}, force = "neutral"})
    end
end
surface.pollute({0,0}, 1000000000)

/c game.player.surface.create_entity({name = "tree-04", position = {-5, 5}, force = "neutral"})


/c
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force = "player", name = "long-handed-inserter"})) do
    surface.create_entity({name="car", position={ent.drop_target.position.x, ent.drop_target.position.y}, force = "player"})
    ent.drop_target.destroy()
    surface.create_entity({name="stack-inserter", position=ent.position, force="player", direction=ent.direction})
    ent.destroy()
end


/c local entity="car"
local count = 0
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({name = entity, force=game.player.force})) do
    count = count + 1
end
game.player.print(count)

/c local entity="stack-inserter"
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({name = entity, force=game.player.force})) do
    if not (ent.drop_target) then
        ent.pickup_target.get_inventory(defines.inventory.chest).setbar()
    end
end

/c local entity="offshore-pump"
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({name = entity, force=game.player.force})) do
    surface.create_entity({name="offshore-pump", position=game.player.selected.position, force = "player", direction = game.player.selected.direction})
    ent.destroy()
end

/c
game.player.selected.connect_neighbour({target_entity = game.player.surface.find_entity("substation", {50, 50}), wire=defines.wire_type.copper})

/c local surface = game.player.surface
surface.create_entity({name="offshore-pump", position=game.player.selected.position, force = "player", direction = game.player.selected.direction})

/c
local surface = game.player.surface
local all_cars = surface.find_entities_filtered({force = "player", type = "car"})
local all_belts = surface.find_entities_filtered({type = "belt", force = "player"})
for key, car in pairs(all_cars) do
    for key2, belt in pairs (all_belts) do
        if (car.position.x == belt.position.x)
        entity.active = true
    else
        entity.active = false
    end
end

/c
local x_coord = game.player.selected.position.x
local y_coord = game.player.selected.position.y
local function round_to_closest_tile_with_offset(x)
    x = math.floor(x) + 0.5
    return (x)
end
game.player.print(x_coord.. "," .. y_coord)
game.player.print(round_to_closest_tile_with_offset(x_coord) .. "," .. round_to_closest_tile_with_offset(y_coord))





/c
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force = "player", name = "stone-wall"})) do
    local X_coord = ent.position.x
    local Y_coord = ent.position.y
    ent.destroy()
    surface.create_entity({name="titanium-wall", position={X_coord, Y_coord}, force = "player"})
end

/c
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force = "player", name = "express-transport-belt"})) do
    local X_coord = ent.position.x
    local Y_coord = ent.position.y
    local direction_foo = ent.direction
    ent.destroy()
    surface.create_entity({name="rapid-transport-belt-mk2", position={X_coord, Y_coord}, force = "player", direction = direction_foo})
end

/c
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force = "player", name = "stack-inserter"})) do
    if not (ent.pickup_target) then
        if (ent.direction == 6) then
            game.player.print(ent.name)
            if not (surface.find_entity("straight-rail", {ent.position.x - 1.5, ent.position.y})) then
                surface.create_entity({name="car", position={(ent.position.x - 1.5), ent.position.y}, force = "player", direction=ent.direction})
            end
        end
        if (ent.direction == 2) then
            game.player.print(ent.name)
            if not (surface.find_entity("straight-rail", {ent.position.x + 1.5, ent.position.y})) then
                surface.create_entity({name="car", position={(ent.position.x + 1.5), ent.position.y}, force = "player", direction=ent.direction})
            end
        end
    end
end

/c local entity="car"
local count = 0
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({name = entity, force=game.player.force})) do
    ent.insert("nuclear-fuel")
    count = count + 1
end
game.player.print(count)

/c local ent_type="container"
local count = 0
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({type = ent_type, force=game.player.force})) do
    ent.clear_items_inside()
    count = count + 1
end
for key, ent in pairs(surface.find_entities_filtered({type = "cargo-wagon", force=game.player.force})) do
    ent.clear_items_inside()
    count = count + 1
end
game.player.print(count)


/c local ent_type="assembling-machine"
local count = 0
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({type = ent_type, force=game.player.force})) do
    ent.insert("productivity-module-3")
    count = count + 1
end
game.player.print(count)


/c local ent_type="beacon"
local count = 0
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({type = ent_type, force=game.player.force})) do
    ent.insert("speed-module-3")
    count = count + 1
end
game.player.print(count)




/c local surface = game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
    if (ent.type == "entity-ghost") then
        revived = ent.revive()
    end
end
for key, ent in pairs(surface.find_entities_filtered() do
    if (ent.to_be_deconstructed(game.player.force)) then
        ent.destroy()
    end
end
for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
    if (ent.type == "item-request-proxy") then
        for key, req in  pairs (ent.item_requests) do
            game.player.print(key .. req)
            ent.proxy_target.insert({name = key, count = req})
            ent.item_requests = nil
        end
    end
end


/c
for x=1, 2 do game.player.print(game.player.selected.get_inventory(x).get_contents())
end



/c local surface = game.player.surface
prime_inserters(surface)

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
