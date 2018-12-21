/silent-command
local surface=game.player.surface
local solar_based_entities = {"solar-panel", "accumulator", "substation"}

local tile_paste_length = 32
local start_tile = 64
local GW_of_power_desired = 1
local times_to_paste = math.ceil((GW_of_power_desired / .040320))
local entity_pool = surface.find_entities_filtered({area={{-1000, (start_tile)}, {1000, start_tile + tile_paste_length}}, force="player", name = solar_based_entities})
local ticks_per_paste = 2
local start_tick = game.tick

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

script.on_event(defines.events.on_tick, function(event)
    for current_paste = 1, times_to_paste do
        if (game.tick == (start_tick + (current_paste * ticks_per_paste))) then
            clean_paste_area(surface, -175, ((current_paste + 1) * tile_paste_length), 175, (current_paste * tile_paste_length + 4))
            game.forces["player"].chart(surface, {{x = -175, y = ((current_paste) * tile_paste_length)}, {x = 175, y = ((current_paste+1) * tile_paste_length + 4)}})
            for key, ent in pairs(entity_pool) do
                local x_offset = ent.position.x + 0
                local y_offset = ent.position.y + (tile_paste_length*current_paste)
                local create_entity_values = {name = ent.name, position={x_offset, y_offset}, direction=ent.direction, force="player"}
                surface.create_entity(create_entity_values)
            end
        end
    end
    if (game.tick == (start_tick + (times_to_paste * ticks_per_paste) + 300)) then
        game.forces["player"].chart_all()
        script.on_event(defines.events.on_tick, nil)
    end
end);
