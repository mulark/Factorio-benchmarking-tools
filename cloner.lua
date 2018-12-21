/silent-command
local surface=game.player.surface
local low_priority_entities = {"beacon", "locomotive", "cargo-wagon", "logistic-robot", "construction-robot", "fluid-wagon"}
local start_tick = (game.tick + 1)
local inserters_that_were_cloned = {}

local tile_paste_length = 64
local start_tile = 0
local times_to_paste = 1
local entity_pool = surface.find_entities_filtered({area={{-1000, (start_tile-tile_paste_length)}, {1000, start_tile}}, force="player"})
local ticks_per_paste = 2
local try_to_prime_inserters_pulling_from_belt = false
local use_exact_power_wires = false
local use_smart_map_charting_wip = false
local copy_belt_contents = true
local clear_paste_area = false


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
    copy_inventories_and_fluid(original_entity, cloned_entity)
    copy_progress_bars(original_entity, cloned_entity)
    copy_resources(original_entity, cloned_entity)
    copy_circuit_connections(original_entity, cloned_entity)
    if (use_exact_power_wires) then
        copy_exact_power(original_entity, cloned_entity)
    end
    copy_train(original_entity, cloned_entity)
    cloned_entity.update_connections()
    if (copy_belt_contents) then
        copy_transport_line_contents(original_entity, cloned_entity)
    end
end

function copy_properties (original_entity, cloned_entity)
    if (original_entity.type == "loader") then
        cloned_entity.loader_type = original_entity.loader_type
    end
    cloned_entity.copy_settings(original_entity)
    cloned_entity.orientation = original_entity.orientation
    cloned_entity.direction = original_entity.direction
end

local function internal_inventory_copy(original_entity, cloned_entity, INV_DEFINE)
    if (original_entity.get_inventory(INV_DEFINE)) then
        local working_inventory = original_entity.get_inventory(INV_DEFINE)
        for k=1, #working_inventory do
            if (working_inventory[k].valid_for_read) then
                cloned_entity.get_inventory(INV_DEFINE).insert(working_inventory[k])
            end
        end
    end
end

function copy_inventories_and_fluid (original_entity, cloned_entity)
    internal_inventory_copy(original_entity, cloned_entity, defines.inventory.chest)
    internal_inventory_copy(original_entity, cloned_entity, defines.inventory.rocket_silo_result)
    internal_inventory_copy(original_entity, cloned_entity, defines.inventory.furnace_source)
    internal_inventory_copy(original_entity, cloned_entity, defines.inventory.furnace_result)
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

function copy_progress_bars(original_entity, cloned_entity)
    if has_value(original_entity.type, {"rocket-silo", "assembling-machine", "furnace"}) then
        cloned_entity.crafting_progress = original_entity.crafting_progress
        if (original_entity.type == "rocket-silo") then
            cloned_entity.rocket_parts = original_entity.rocket_parts
        end
    end
    if (original_entity.burner) then
        if (original_entity.burner.currently_burning) then
            cloned_entity.burner.currently_burning = original_entity.burner.currently_burning
            cloned_entity.burner.remaining_burning_fuel = original_entity.burner.remaining_burning_fuel
        end
    end
end

function copy_resources (original_entity, cloned_entity)
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
    if(original_entity.type == "power-switch") then
        game.players[1].print("WARN: it's not possible to copy the power connections for power switches in 0.16.51")
    end
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

function copy_train (original_entity, cloned_entity)
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

function copy_transport_line_contents (original_entity, cloned_entity)
    local transport_lines_present = 0
    if (original_entity.type == "splitter") then
        transport_lines_present = 8
    end
    if (original_entity.type == "underground-belt") then
        transport_lines_present = 4
        if (original_entity.belt_to_ground_type == "input") then
            if (original_entity.direction == 2 or original_entity.direction == 4) then
                if (original_entity.neighbours) then
                    local offset_x = original_entity.neighbours.position.x - original_entity.position.x
                    local offset_y = original_entity.neighbours.position.y - original_entity.position.y
                    if not (cloned_entity.neighbours) then
                        cloned_entity.surface.create_entity({name = cloned_entity.name, position = {cloned_entity.position.x + offset_x, cloned_entity.position.y + offset_y}, force = cloned_entity.force, direction = cloned_entity.direction, type = "output"})
                    end
                end
            end
        end
    end
    if (original_entity.type == "transport-belt") then
        transport_lines_present = 2
    end
    for x = 1, transport_lines_present do
        local current_position = 0
        for item_name, item_amount in pairs(original_entity.get_transport_line(x).get_contents()) do
            for _=1, item_amount do
                cloned_entity.get_transport_line(x).insert_at(current_position,{name = item_name})
                current_position = current_position + 0.28125
            end
        end
    end
end

function clean_entity_pool (entity_pool)
    for key, ent in pairs(entity_pool) do
        if has_value(ent.type,{"player", "entity-ghost", "tile-ghost"}) then
            entity_pool[key] = nil
        else
            if not has_value(ent.type, {"decider-combinator", "arithmetic-combinator"}) then
                ent.active = false
            end
        end
    end
end

local function first_pass_throw_away_unneeded_inserters (pool)
    local freshpool = {}
    for key, ent in pairs (pool) do
        if (ent.pickup_target) then
            if has_value(ent.pickup_target.type, {"underground-belt", "transport-belt"}) then
                if (ent.drop_target) then
                    if (ent.drop_target.type == "container") then
                        table.insert(freshpool, ent)
                    end
                end
            end
        end
    end
    return freshpool
end

local function check_primed_inserter (ent)
    if (ent.inserter_stack_size_override == 1) then
        return true
    end
    if (ent.held_stack.valid_for_read) then
        if (ent.held_stack.prototype.stack_size == 1) then
            return true
        end
        if (ent.held_stack_position.x == ent.drop_position.x) then
            if (ent.held_stack_position.y == ent.drop_position.y) then
                return true
            end
        end
        local held_item = ent.held_stack.name
        local drop_inv = ent.drop_target.get_inventory(defines.inventory.chest)
        local inserter_stack_size = ent.inserter_stack_size_override
        if (ent.inserter_stack_size_override == 0) then
            inserter_stack_size = 12
        end
        local items_inside = drop_inv.get_item_count(held_item) + inserter_stack_size
        local item_capacity = (drop_inv.getbar() - 1) * game.item_prototypes[held_item].stack_size
        if ((item_capacity / items_inside) == 0) then
            return false
        end
        if ((item_capacity % items_inside) > 0) then
            return true
        end
    end
    if not (ent.held_stack.valid_for_read) then
        local item_to_hold = ""
        for name, _ in pairs (ent.pickup_target.get_transport_line(2).get_contents()) do
            item_to_hold = name
        end
        if (item_to_hold == "") then
            for name, _ in pairs (ent.pickup_target.get_transport_line(1).get_contents()) do
                item_to_hold = name
            end
        end
        if (item_to_hold == "") then
            item_to_hold = ent.drop_target.get_inventory(defines.inventory.chest)[1].name
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

script.on_event(defines.events.on_tick, function(event)
    for current_paste = 1, times_to_paste do
        if (game.tick == start_tick) then
            clean_entity_pool(entity_pool)
        end
        if (game.tick == (start_tick + (current_paste * ticks_per_paste))) then
            if (clear_paste_area) then
                clean_paste_area(surface,  -1000, -1 * ((current_paste + 1) * tile_paste_length + 4), 1000, -1 * (current_paste * tile_paste_length))
            end
            for key, ent in pairs(entity_pool) do
                local x_offset = ent.position.x + 0
                local y_offset = ent.position.y - (tile_paste_length*current_paste)
                local create_entity_values = {name = ent.name, position={x_offset, y_offset}, direction=ent.direction, force="player"}
                if not has_value(ent.type, low_priority_entities) then
                    if (ent.type == "underground-belt") then
                        create_entity_values.type = ent.belt_to_ground_type
                    end
                    surface.create_entity(create_entity_values)
                    local newent = surface.find_entity(ent.name, {x_offset, y_offset})
                    copy_entity(ent, newent)
                    if (newent.type == "inserter") then
                        table.insert(inserters_that_were_cloned, newent)
                    end
                    newent = nil
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
                    newent = nil
                end
            end
        end
        if (game.tick == (start_tick + ((times_to_paste + 1)*ticks_per_paste) + 600 )) then
            for key, ent in pairs(entity_pool) do
                if (ent.valid) then
                    ent.active = true
                end
            end
            if not (use_smart_map_charting) then
                game.forces["player"].chart_all()
            end
            if (try_to_prime_inserters_pulling_from_belt == true) then
                local inserters_to_prime = first_pass_throw_away_unneeded_inserters(inserters_that_were_cloned)
                for _, ent in pairs(inserters_to_prime) do
                    if not (check_primed_inserter(ent)) then
                        if (ent.held_stack.valid_for_read) then
                            ent.drop_target.remove_item({name = ent.held_stack.name, amount = 1})
                        else
                            ent.drop_target.remove_item({name = ent.drop_target.get_inventory(defines.inventory.chest)[1].name, amount = 1})
                        end
                    end
                end
            end
            script.on_event(defines.events.on_tick, nil)
        end
    end
end);
