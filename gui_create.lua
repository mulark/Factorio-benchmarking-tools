/silent-command
local gui = {}
gui.create_gui = function (player)
    gui.clear_gui(player)
    local mod_button = mod_gui.get_button_flow(game.player).add{type="sprite-button", name="region-cloner-main-button", sprite="achievement/lazy-bastard", tooltip="Region Cloner"}
    local mod_frame = mod_gui.get_frame_flow(game.player).add{type="frame", name="region-cloner-control-window", caption="Region Cloner", direction="vertical"}
    mod_frame.style.visible = false
    local coord_gui_table = mod_frame.add{type="table", column_count=3, name="region-cloner-coordinate-table"}
        coord_gui_table.add{type="label", name="left_top_description", caption="Left_top", tooltip="The top left corner coordinate of the region you wish to copy"}
        coord_gui_table.add{type="textfield", name="left_top_x"}
        coord_gui_table.add{type="textfield", name="left_top_y"}
        coord_gui_table.add{type="label", name="right_bottom_description", caption="Right_bottom", tooltip="The bottom right corner coordinate of the region you wish to copy"}
        coord_gui_table.add{type="textfield", name="right_bottom_x"}
        coord_gui_table.add{type="textfield", name="right_bottom_y"}

    local drop_down_table = mod_frame.add{type="table", column_count=4, name="region-cloner-drop_down_table"}
        drop_down_table.add{type="label", caption="Direction to Copy"}
        drop_down_table.add{type="drop-down", items={"North","East","South","West"}, selected_index=1}
        drop_down_table.add{type="label", caption="Number of copies", tooltip="How many copies of the area above will be made. Note that you will end up with 1 more copy than the number selected here (the original area)"}
        drop_down_table.add{type="textfield", name="number_of_copies", text=1}
        drop_down_table["number_of_copies"].style.left_padding = 8
        drop_down_table["number_of_copies"].style.right_padding = 8
        drop_down_table["number_of_copies"].style.align = "right"

    local button_control_table = mod_frame.add{type="table", column_count=2}
        button_control_table.add{type="button", name="restrict_selection_area_to_entities", caption="Shrink Selection Area", tooltip="Reduces the size of your selection area to include only the entities found in that area"}
        local get_selection_tool_button = button_control_table.add{type="button", name="get_selection_tool_button", caption="Get Selection Tool"}
        local copy_paste_start_button = button_control_table.add{type="button", name="issue_copy_pastes", caption="Start"}
        copy_paste_start_button.style.align="right"
end

gui.clear_gui = function (player)
    local mod_button = mod_gui.get_button_flow(player)
    local mod_frame = mod_gui.get_frame_flow(player)
    if mod_button["region-cloner-main-button"] then
        mod_button["region-cloner-main-button"].destroy()
    end
    if mod_frame["region-cloner-control-window"] then
        mod_frame["region-cloner-control-window"].destroy()
    end
end

util.textfield_to_number = function(textfield)
  local number = tonumber(textfield.text)
  if textfield.text and number then
    return number
  else
    return false
  end
end

local function restrict_selection_area_to_entities(left, top, right, bottom, surface)
    local key_left_ent = {}
    local key_right_ent = {}
    local key_top_ent = {}
    local key_bottom_ent = {}
    for _, ent in pairs(surface.find_entities_filtered{area={{left, top},{right,bottom}}, force="player"}) do
        if not has_value(ent.type, entites_not_allowed_type) then

        end
    end
end

local function validate_player_copy_paste_settings(player)
    local mod_window = mod_gui.get_frame_flow(player).["region-cloner-control-window"]
    local coord_table = mod_window["region-cloner-coordinate-table"]
    for _,field in pairs (coord_table.children_names) do
        if not(util.textfield_to_number(field) then
            player.print(field .. " invalid number")
            return false
        end
    end

end

local function issue_copy_paste(player)

end


gui.create_gui(game.player)
script.on_event({defines.events.on_gui_click}, function(event)
    local player = game.players[event.player_index]
    local frame_flow = mod_gui.get_frame_flow(player)
    local clicked_on = event.element.name
    if (clicked_on == "region-cloner-main-button") then
        frame_flow["region-cloner-control-window"].style.visible = not frame_flow["region-cloner-control-window"].style.visible
    end
    if (clicked_on == "get_selection_tool_button") then
        player.clean_cursor()
        if (player.cursor_stack.valid_for_read) then
            player.print("Your inventory is too full to use this tool")
            return
        end
        player.cursor_stack.set_stack("dummy-selection-tool")
    end
    if (clicked_on == "restrict_selection_area_to_entities") then
        local old_left = frame_flow["region-cloner-control-window"]["region-cloner-coordinate-table"]["left_top_x"].text
        local old_top = frame_flow["region-cloner-control-window"]["region-cloner-coordinate-table"]["left_top_y"].text
        local old_right = frame_flow["region-cloner-control-window"]["region-cloner-coordinate-table"]["right_bottom_x"].text
        local old_bottom = frame_flow["region-cloner-control-window"]["region-cloner-coordinate-table"]["right_bottom_y"].text
        local new_left, new_top, new_right, new_bottom = restrict_selection_area_to_entities()
    end
    if (clicked_on == "issue_copy_pastes") then
        if (validate_player_copy_paste_settings(player)) then
            issue_copy_paste(player)
        end
    end
end)
script.on_event({defines.events.on_player_selected_area}, function(event)
    local player = game.players[event.player_index]
    local frame_flow = mod_gui.get_frame_flow(player)
    local coord_table = frame_flow["region-cloner-control-window"]["region-cloner-coordinate-table"]
    if coord_table["left_top_x"] then
        coord_table["left_top_x"].text = math.floor(event.area.left_top.x)
    end
    if coord_table["left_top_y"] then
        coord_table["left_top_y"].text = math.floor(event.area.left_top.y)
    end
    if coord_table["right_bottom_x"] then
        coord_table["right_bottom_x"].text = math.ceil(event.area.right_bottom.x)
    end
    if coord_table["right_bottom_y"] then
        coord_table["right_bottom_y"].text = math.ceil(event.area.right_bottom.y)
    end
end)
