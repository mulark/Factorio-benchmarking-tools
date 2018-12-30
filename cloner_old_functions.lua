--[[Features cut from the main cloner.lua--]]

function copy_exact_power (original_entity, cloned_entity)
    if (original_entity.type == "power-switch") then
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
            if (ent.drop_target.get_inventory(defines.inventory.chest)[1].valid_for_read) then
                item_to_hold = ent.drop_target.get_inventory(defines.inventory.chest)[1].name
            else
                return true
            end
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
