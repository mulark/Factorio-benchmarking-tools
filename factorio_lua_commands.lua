/c game.player.selected.connect_neighbour({target_entity = (game.player.surface.find_entity(game.player.selected.name, {(game.player.selected.position.x+5), game.player.selected.position.y})), wire=defines.wire_type.red})


/c game.player.selected.insert({name="iron-plate", count=99})


/c
game.player.force.technologies['mining-productivity-16'].researched=false;
local times=1840
for x=1, times do game.player.force.technologies['mining-productivity-16'].researched=true end

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

/c
local player = game.player
local function get_region_bounding_box(player)
    local bounding_box = {}
    local left_top = {}
    local right_bottom = {}
    local coord_table = mod_gui.get_frame_flow(player)["region-cloner_control-window"]["region-cloner_coordinate-table"]
    left_top["x"] = tonumber(coord_table["left_top_x"].text)
    left_top["y"] = tonumber(coord_table["left_top_y"].text)
    right_bottom["x"] = tonumber(coord_table["right_bottom_x"].text)
    right_bottom["y"] = tonumber(coord_table["right_bottom_y"].text)
    bounding_box["left_top"] = left_top
    bounding_box["right_bottom"] = right_bottom
    player.print(serpent.line(bounding_box))
    return bounding_box
end
local box = get_region_bounding_box(player)
for _, ent in pairs(game.player.surface.find_entities_filtered{area=box}) do
    player.print(ent.name)
end

/c
game.player.print(serpent.line(game.players))

/c
for idx, player in pairs (game.players) do
    game.player.print(idx)
end

/silent-command
game.player.surface.create_entity({name="offshore-pump",position=game.player.selected.position, direction=4, force = "player"})
game.player.selected.destroy()

/silent-command
game.player.surface.create_entity({name="crude-oil",position=game.player.selected.position, force = "neutral", amount=1000000})
game.player.selected.destroy()

/c
local clone = game.player.surface.create_entity({position=game.player.selected.position, name="electric-mining-drill", force="player"})
local left = clone.position.x - clone.prototype.mining_drill_radius
local right = clone.position.x + clone.prototype.mining_drill_radius
local top = clone.position.y - clone.prototype.mining_drill_radius
local bottom = clone.position.y + clone.prototype.mining_drill_radius
local flag = false
for _,resource in pairs (game.player.surface.find_entities_filtered({type="resource", area={{left, top}, {right, bottom}}, force="neutral"})) do
    if (resource) then
        flag = true
    end
end
if not (flag) then
    clone.destroy()
end

/c
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({})) do
    if string.find(ent.name, "creative") then
        ent.destroy()
    end
end

/c
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({})) do
    if string.find(ent.name, "reactor") then
        if (ent.temperature) then
            ent.temperature = 500
        end
    end
end

/c
for key, ent in pairs(game.player.surface.find_entities_filtered({name={"logistic-chest-requester"}})) do

end

/c
for key, ent in pairs(game.player.surface.find_entities_filtered({name={"radar"}})) do
    ent.destroy()
end
/c
for key, ent in pairs(game.player.surface.find_entities_filtered({name={"solar-panel", "accumulator"}})) do
    ent.destroy()
end
game.player.surface.create_entity({name = "electric-energy-interface", force = "player", position = {2876, -1446}})

/c
local player = game.player
player.insert("electric-energy-interface")
player.insert("infinity-chest")


/c
local count = 0
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player", name="solar-panel"})) do
    count = count + 1
end
game.player.print(count)

/c
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player", name="electric-mining-drill"})) do
    if (ent.mining_target) then
        ent.mining_target.amount=10000000
    end
end

/c
local count = 0
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force={"neutral", "enemy"}, name={"solar-panel", "accumulator"}, invert=true})) do
    count = count + 1
end
game.player.print(count)


/c game.player.insert("dummy-selection-tool")
script.on_event(defines.events.on_player_selected_area, function(args) game.print(serpent.line(args.area)) end)


/c
local surface= game.player.surface
game.forces["player"].chart(surface, {{x = -110, y = -3830}, {x = 671, y = 0}})


/c
local surface= game.player.surface
game.write_file("item_amounts.csv", "Entity_name,Entity_amount\n", true)
for _, prototype in pairs (game.entity_prototypes) do
    local count = 0
    for _, ent in pairs (surface.find_entities_filtered({name = prototype.name, force = "player"})) do
        count = count + 1
    end
    if (count > 0) then
        game.write_file("item_amounts.csv", prototype.name .. "," .. count .. "\n", true)
    end
end

/c
local surface= game.player.surface
for _, prototype in pairs (game.entity_prototypes) do
    local count = 0
    for _, ent in pairs (surface.find_entities_filtered({name = prototype.name, force = "player"})) do
        count = count + 1
    end
    if (count > 0) then
        game.player.print(prototype.name .. "," .. count)
    end
end


/c

script.on_event(defines.events.on_marked_for_deconstruction, function(event)
    game.players[1].print(event.entity.last_user.name)
    if not event.entity.last_user or event.entity.name == 'entity-ghost' or event.entity.last_user == game.players[event.player_index] then
        game.players[1].print("allowed")
    else
        event.entity.cancel_deconstruction('player')
        game.players[1].print("not allowed")
    end
end)


/c
local count = 0
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player", name="cargo-wagon"})) do
    count = count + 1
end
game.player.print(count)


/c
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({name="car"})) do
    ent.clear_items_inside()
end

/c game.player.surface.delete_chunk({math.floor(game.player.selected.position.x / 32), math.floor(game.player.selected.position.y / 32)})


/c local surface = game.player.surface
for x=-7, 7 do
    for y=-7, 7 do
        surface.delete_chunk({x, y})
    end
end


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




/c
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force=game.player.force, name="car"})) do
    local times=80
    for x=1,times do
        ent.get_inventory(2).set_filter(x, "raw-fish")
    end
    ent.get_inventory(2).set_filter(1, "copper-cable")
end

/c
for abc, def in pairs (game.player.selected.prototype.collision_mask) do
    game.player.print(abc .. " " .. game.player.selected.name)
end

/c
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force=game.player.force, name="car"})) do
    local times=80
    for x=1,times do
        ent.get_inventory(2).set_filter(x, "raw-fish")
    end
    ent.get_inventory(2).set_filter(1, "copper-plate")
end

--[[Clear the contents of a train--]]
/c
for key, ent in pairs(game.player.selected.train.carriages) do
    ent.clear_items_inside()
end



/c
function newlog(text)
    log(text)
end


/c
local surface=game.player.surface
for key,ent in pairs(surface.find_entities_filtered{name = "tank"}) do
    ent.insert("nuclear-fuel")
end

/c
local surface=game.player.surface
for key,ent in pairs(surface.find_entities_filtered{type = {"container", "inserter"}}) do
    ent.clear_items_inside()
end

/c
local surface=game.player.surface
for key,ent in pairs(surface.find_entities_filtered{type = {"inserter"}}) do
    ent.active = true
end


/c game.player.surface.create_entity{name="car", position={game.player.selected.position.x+0, game.player.selected.position.y+32}, direction=defines.direction.east, force=game.player.selected.force}

/c
local surface=game.player.surface
for key, ent in pairs (surface.find_entities_filtered{force="player"}) do
    if (ent.position.x > 256) then
        ent.destroy()
    end
end

/c
local surface=game.player.surface
for key, ent in pairs (surface.find_entities_filtered{force="neutral"}) do
    ent.destroy()
end

/c commands.add_command("foo", "a", function(param)
    local player = game.players[param.player_index]
    game.player.print("foo")
    log("foo")
end)

/c commands.add_command("slap", "Slap a player. (usage: /slap somePlayerName)", function(param)
	local player = game.players[param.player_index]
 	if param.parameter then
		local victim = game.players[param.parameter]
		if victim then
			if victim.connected then
	            startSlapping(victim, player, SLAP_DEFAULT_AMOUNT)
	        else
	            slSays(player, victim.name .. " is not online")
	        end
		else
			slSays(player, "Player not found: (" .. param.parameter .. ")")
		end
 	else
		slSays(player, "Player name needed. (usage: /slap somePlayerName)")
	end
end)



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
for x=0, 0.75, 0.25 do
    game.player.selected.get_transport_line(3).insert_at(x,{name="iron-ore"})
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


/c
if (game.player.selected.train.front_stock == game.player.selected) then
    game.player.print("true")
end

/c
if (game.player.selected.disconnect_rolling_stock(defines.)== game.player.selected) then
    game.player.print("true")
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


/c local namen="logistic-chest-buffer"
local count = 0
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({name = namen, force = "player"})) do
        game.player.print("X: " .. ent.position.x .. "Y: " .. ent.position.y)
        game.player.teleport({ent.position.x, ent.position.y})
        count = count + 1
end
game.player.print(count)

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

/c game.forces.player.chart(game.player.surface, {{x = -893, y = -20960}, {x = -272, y = 640}})

/c game.player.force.chart(game.player.surface, {{-896, -21000},{192, 640}})


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

/c
if (game.player.selected.neighbours[1][1]) then
    game.player.print("has")
end
for _,ent in pairs(game.player.selected.neighbours[1]) do
    game.player.print(ent.position)
end

/c
for key,ent in pairs(game.player.surface.find_entities_filtered({name={"pipe", "pipe-to-ground", "storage-tank", "pump"}, force="player"})) do
    if (ent.fluidbox[1]) then
        if (ent.fluidbox[1].name == "water") then
            ent.destroy()
        end
    end
end

/silent-command
local function has_value (val, tab)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
local function clean_pool(pool)
    local freshpool = {}
    for _,ent in pairs (pool) do
        if (ent.get_recipe()) then
            if has_value(ent.get_recipe().name, {"advanced-oil-processing", "heavy-oil-cracking", "light-oil-cracking", "sulfur", "sulfuric-acid", "explosives"}) then
                table.insert(freshpool, ent)
            end
        end
    end
    return freshpool
end
local function find_direction_for_offshore(entity_needing_offshore)
    local direction_for_offshore = entity_needing_offshore.direction
    if (entity_needing_offshore.name == "oil-refinery") then
        if (entity_needing_offshore.direction <= 4) then
            direction_for_offshore = direction_for_offshore + 4
        else
            direction_for_offshore = direction_for_offshore - 4
        end
    end
    return direction_for_offshore
end
local function place_offshores(pool)
    for _,ent in pairs (pool) do
        local water_pipe_input_entity = ent.neighbours[1][1]
        if (water_pipe_input_entity) then
            if (water_pipe_input_entity.name ~= "offshore-pump") then
                local direction_for_offshore = find_direction_for_offshore(ent)
                ent.surface.create_entity({name="offshore-pump", position= water_pipe_input_entity.position, force="player", direction=direction_for_offshore})
            end
        else
            local length_offset = 2
            local width_offset = 1
            local x_decode = 0
            local y_decode = 0
            local direction_for_offshore = find_direction_for_offshore(ent)
            game.player.print(direction_for_offshore)
            if (ent.name == "oil-refinery") then
                length_offset = 3
            end
            if (direction_for_offshore == 0) then
                local x_decode = -1 * width_offset
                local y_decode = -1 * length_offset
            end
            if (direction_for_offshore == 2) then
                local x_decode = 1 * length_offset
                local y_decode = -1 * width_offset
            end
            if (direction_for_offshore == 4) then
                local x_decode = -1 * width_offset
                local y_decode = 1 * length_offset
            end
            if (direction_for_offshore == 6) then
                local x_decode = -1 * length_offset
                local y_decode = 1 * width_offset
            end
            local x_pos = ent.position.x + x_decode
            local y_pos = ent.position.y + y_decode
            ent.surface.create_entity({name="offshore-pump", position= {x_pos, y_pos}, force="player", direction=direction_for_offshore})
        end
    end
end
local surface = game.player.surface
local water_input_entities = {"oil-refinery", "chemical-plant"}
entity_pool = surface.find_entities_filtered{name=water_input_entities, force="player"}
entity_pool = clean_pool(entity_pool)
place_offshores(entity_pool)


/c
for x=-150,150 do
    for y=-150,150 do
        game.player.surface.create_entity({name="express-transport-belt", force="player", position={x,y}, direction = 0})
    end
end

/c
for x=-150,150 do
    for y=-150,150 do
        game.player.surface.create_entity({name="car", force="player", position={x*3,y*2.1}, direction = 4})
    end
end

/c
for x=-150,150 do
    for y=-2750,750 do
        game.player.surface.create_entity({name="express-transport-belt", force="player", position={x*3,y}, direction = 0})
    end
end

/c
game.player.chart(game.player.surface, {{-750, -2750},{750,750}})


/c
--[[create car, remember to set direction]]
for x=-150,150 do
    for y=-150,150 do
        game.player.surface.create_entity({name="car", force="player", position={x*3,y*2.1}, direction = 4})
    end
end

/c
--[[create car, remember to set direction]]
for x=-150,150 do
    for y=-150,150 do
        game.player.surface.create_entity({name="car", force="player", position={x*5,y*5}, direction = 4})
    end
end


/c
local tiles={}
for x=-55,50 do
    for y=-700,150 do
        table.insert(tiles, {name = "refined-concrete", position = {x,y}})
    end
end
game.player.surface.set_tiles(tiles, false)

/c
local count = 0
for a, b in pairs(game.player.surface.find_entities_filtered({name="car"})) do
    count = count + 1
end
game.print(count)

/c
local x = 0
local surface = game.player.surface
for _, prototype in pairs(game.entity_prototypes) do
    game.player.print(prototype.type)
    if prototype.type ~= "projectile" then
        if prototype.type ~= "explosion" then
            surface.create_entity({name= prototype.name, position = {5*x, 64}, force="player"})
        end
    end
    x = x + 1
end

/c game.player.print(serpent.line(game.entity_prototypes.name))

/c
for _, ent in pairs(game.player.surface.find_entities_filtered{force="player"}) do
    local var = "false"
    if ent.supports_direction then
        var = "true"
        game.player.print(ent.name .. " supports_direction: " .. var)
    end

end



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



/c local ent_force = "player"
local count = 0
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force = ent_force})) do
    if (ent.position.y < -100) then
        ent.destroy()
    end
end


/c
ent = game.player.selected
for name, amount in pairs (ent.get_transport_line(2).get_contents()) do
    game.player.print(name .. " " .. amount)
    if (amount == 0) then
        game.player.print("name was nil?")
    end
end

/c
ent = game.player.selected
function true_or_false (ent)
    if not (ent.held_stack.valid_for_read) then
        local item_to_hold = ""
        for name, _ in pairs (ent.pickup_target.get_transport_line(2).get_contents()) do
            game.player.print(name)
            item_to_hold = name
        end

        local items_inside = ent.drop_target.get_item_count(item_to_hold)
        local slots = ent.drop_target.get_inventory(defines.inventory.chest).getbar() - 1
        local item_capacity = slots * game.item_prototypes[item_to_hold].stack_size
        if ((items_inside % item_capacity) ~= 0) then
            items_inside = items_inside + 12
            if ((items_inside % item_capacity) ~= 0) then
                return true
            end
        end
    end
    return false
end
game.player.print(true_or_false(ent))




/c
for name, amount in pairs(game.player.selected.get_inventory(defines.inventory.fuel).get_contents()) do
    game.player.print(name)
end

/c local ent_force = "player"
local ent_name = "car"
local count = 0
local surface=game.player.surface
for key, ent in pairs(surface.find_entities_filtered({name = ent_name, force = ent_force})) do
    if (ent.name == ent_name) then
        ent.destroy()
    end
end

/c local surface = game.player.surface
for key,ent in pairs(surface.find_entities_filtered{force="player"}) do



/c local surface = game.player.surface
for key, ent in pairs(surface.find_entities_filtered({force="player"})) do
    if (ent.type == "entity-ghost") then
        revived = ent.revive()
    end
end
for key, ent in pairs(surface.find_entities_filtered({surface=game.player.surface})) do
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

/measured-command
local event = {}
event.area = {{-32, 32}, {0, 64}}
event.area.left_top = {-32, 32}
event.area.right_bottom = {0, 64}
event.area.left_top.x = -32
event.area.left_top.y = 32
event.area.right_bottom.x = 0
event.area.right_bottom.y = 64
event.surface = game.player.surface

local function has_value (val, tab)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local function pave_chunk(event)
    local tiles = {}
    for x = event.area.left_top.x, event.area.right_bottom.x do
        for y = event.area.left_top.y, event.area.right_bottom.y do
            local TILE_COMPARE_NAME = event.surface.get_tile({x, y}).name
            if not has_value(TILE_COMPARE_NAME, {"water", "deepwater", "refined-concrete"}) then
                table.insert(tiles, {name = "refined-concrete", position = {x,y}})
            end
            TILE_COMPARE_NAME = nil
        end
    end
    event.surface.set_tiles(tiles, false)
    tiles = nil
end
pave_chunk(event)


/c local surface = game.player.surface
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

/c
for key,ent in pairs (game.player.surface.find_entities_filtered{}) do
    ent.destroy()
end

/c
local count = 0
for key,ent in pairs (game.player.surface.find_entities_filtered{name="locomotive"}) do
    count = count + 1
end
game.print(count)

/c game.player.print(serpent.line(game.player.selected.get_control_behavior().get_signal(1)))

/c game.player.print(serpent.line(game.player.selected.get_control_behavior().enabled))

/c
for key,ent in pairs (game.player.surface.find_entities_filtered{name="locomotive"}) do
    ent.insert("nuclear-fuel")
end

/c
for _, ent in pairs(game.player.surface.find_entities_filtered{}) do
    if (ent.position.y > 0) then
        ent.destroy()
    end
end

/c
for key,ent in pairs (game.player.surface.find_entities_filtered{name="locomotive"}) do
    ent.disconnect_rolling_stock(defines.rail_direction.front)
    ent.train.manual_mode = false
end

/c
for key,ent in pairs (game.player.surface.find_entities_filtered{name="locomotive"}) do
    ent.train.manual_mode = false
end

/c
local tiles={}
for x=0,31 do
    for y=0,31 do
        table.insert(tiles, {name = "refined-concrete", position = {x,y}})
    end
end
game.player.surface.set_tiles(tiles, false)

/c
local beacons_to_refresh = {}
for _, ent in pairs(game.player.surface.find_entities_filtered{name = "beacon"}) do
    table.insert(beacons_to_refresh, ent.position)
    ent.destroy()
end
for _, ent in pairs(game.player.surface.find_entities_filtered{type = "inserter"}) do
    ent.active = true
end
local start = game.tick
script.on_event(defines.events.on_tick, function(event)
    if (game.tick > start) then
        for _, position in pairs(beacons_to_refresh) do
            local refreshed_beacon = game.surfaces[1].create_entity({name="beacon", position = position, force = "player"})
            refreshed_beacon.insert("speed-module-3")
        end
        script.on_event(defines.events.on_tick, nil)
    end
end)

/c
for _, ent in pairs(game.player.surface.find_entities_filtered({name="substation"})) do
    ent.disconnect_neighbour()
end

/c
local count = 0
for _, ent in pairs(game.player.surface.find_entities_filtered({name="substation"})) do
    count = count + 1
end
game.print(count)

/c
for x=-4.5,-400.5,-26 do
    for y=390,82,-8 do
        local ent = game.player.surface.create_entity({name="car", position={x,y}, force="player"})
        ent.get_inventory(defines.inventory.chest).insert("nuclear-fuel")
    end
end

/c
for x=-4.5,-550.5,-26 do
    for y=390,82,-8 do
        local ent = game.player.surface.create_entity({name="car", position={x,y}, force="player"})
        ent.get_inventory(defines.inventory.chest).insert("nuclear-fuel")
    end
end

/c
substation_to_refresh = {}
for _, ent in pairs(game.player.surface.find_entities_filtered{name = "substation"}) do
    table.insert(substation_to_refresh, ent.position)
    ent.destroy()
end
for _, position in pairs(substation_to_refresh) do
    game.surfaces[1].create_entity({name="substation", position = position, force = "player"})
end

/c
for key,ent in pairs (game.player.surface.find_entities_filtered{name="car"}) do
    if (ent.position.x < 0) then
        ent.destroy()
    end
end

/c
local count = 0
for key,ent in pairs (game.player.surface.find_entities_filtered{name="car"}) do
    count = count + 1
    ent.get_inventory(defines.inventory.chest).insert("nuclear-fuel")
end
game.print(count)

/c
for _,ent in pairs(game.player.surface.find_entities_filtered{area={{16, 0},{32, 32}}}) do
    game.print(_ .. " " .. ent.position.x .. ", " .. ent.position.y .. " " .. ent.name)
end

/c
function round_to_rail_grid_midpoint(x)
    local foo = math.floor(x)
    if (foo % 2 ~= 0) then
        return foo
    else
        return foo + 1
    end
end
local sel = game.player.selected
local pos = {round_to_rail_grid_midpoint(sel.position.x) + 0.1, round_to_rail_grid_midpoint(sel.position.y)}
game.print(serpent.line(pos))
for _,ent in pairs(game.player.surface.find_entities_filtered{position=pos}) do
    game.print(_ .. " " .. ent.position.x .. ", " .. ent.position.y .. " " .. ent.name)
end

/c
for _,ent in pairs(game.player.surface.find_entities_filtered{position=game.player.selected.position}) do
    game.print(ent.position.x .. ", " .. ent.position.y .. " " .. ent.name)
end

/c local test = {}
for _, ent in pairs (game.player.surface.find_entities_filtered{position=game.player.selected.position}) do
    test = ent
end
test = nil


/c game.player.print((game.player.selected.orientation * -1)+90 % 360)

/c
local initial_x = 64
local initial_y = 64
for x=0, 1, 0.05 do
    game.player.surface.create_entity{name="car", position = {initial_x * x, initial_y}, force="player"}
end

/c
rotation = 0
for _,ent in pairs(game.player.surface.find_entities_filtered({name="car"})) do
    ent.orientation = rotation
    rotation = rotation + 0.05
end

/c
local least_x = 0
for x=0, 5, 0.01 do
    local test_loco = game.player.surface.create_entity({name="locomotive", position={-91 + x, 19}})
    if not (test_loco) then
        game.print(x)
        return
    end
    test_loco.destroy()
end

/measured-command
local loco1 = game.player.surface.find_entity("cargo-wagon",{-3.5, -33})
for x=0, 100000 do
    loco1.disconnect_rolling_stock(defines.rail_direction.front)
    loco1.disconnect_rolling_stock(defines.rail_direction.back)
    loco1.connect_rolling_stock(defines.rail_direction.front)
    loco1.connect_rolling_stock(defines.rail_direction.back)
end

/measured-command
local loco1 = {}
local surface = game.player.surface
local create_ent_val = {name="locomotive", position={1,1}}
for x=0, 10000 do
    loco1 = surface.create_entity(create_ent_val)
    loco1.destroy()
end
