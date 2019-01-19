/silent-command
--[[This script takes an existing map and places offshore pumps directly into fluid input slots. This has been observed to improve performance. This script also removes all existing pipes with water in them. --]]
--[[In vanilla the fluidbox with index 1 is always water on entities which require water input. Modded entities that do not follow this rule won't work.]]
for key,ent in pairs(game.player.surface.find_entities_filtered({name="offshore-pump"})) do
    ent.destroy()
end
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
        if (entity_needing_offshore.direction < 4) then
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
            water_pipe_input_entity.destroy()
        else
            local length_offset = 2
            local width_offset = 1
            local x_decode = 0
            local y_decode = 0
            local direction_for_offshore = find_direction_for_offshore(ent)
            game.player.print(direction_for_offshore)
            if (ent.name == "oil-refinery") then
                length_offset = 3
                width_offset = -1
            end
            if (direction_for_offshore == 0) then
                x_decode = -1 * width_offset
                y_decode = -1 * length_offset
            end
            if (direction_for_offshore == 2) then
                x_decode = 1 * length_offset
                y_decode = -1 * width_offset
            end
            if (direction_for_offshore == 4) then
                x_decode = 1 * width_offset
                y_decode = 1 * length_offset
            end
            if (direction_for_offshore == 6) then
                x_decode = -1 * length_offset
                y_decode = 1 * width_offset
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
for key,ent in pairs(game.player.surface.find_entities_filtered({name={"pipe", "pipe-to-ground", "storage-tank", "pump"}, force="player"})) do
    if (ent.fluidbox[1]) then
        if (ent.fluidbox[1].name == "water") then
            ent.destroy()
        end
    end
end
