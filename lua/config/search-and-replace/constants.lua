local merge_tables = require("config.utils").merge_tables
local M = {}

---@param title string
---@param row number
local function get_popup_options(title, row)
	return {
		enter = true,
		focusable = true,
		border = {
			style = "rounded",
			text = {
				top = title,
				top_align = "center",
			},
		},
		relative = {
			type = "win",
		},
		position = {
			row = row,
			col = "99%",
		},
		size = {
			width = 15,
			height = 1,
		},
	}
end

local default_input_props = {
	mounted = false,
	original_buf_id = nil,
	original_window_id = nil,
	value = "",
	nui_input = nil,
	popup_options = {},
}
---@type SearchInput
---@param user_props? SearchInput
M.get_search_input_props = function(user_props)
	local popup_options = merge_tables(get_popup_options("Search", 0), user_props and user_props.popup_options or {})
	return merge_tables(default_input_props, {
		visible = false,
		standalone = true, -- is the search input being used on its own or in conjunction with a replace input?
		current_match = nil,
	}, user_props or {})
end

---@type ReplaceInput
---@param user_props? ReplaceInput
M.get_replace_input_props = function(user_props)
	local popup_options = merge_tables(get_popup_options("Replace", 4), user_props and user_props.popup_options or {})
	return merge_tables(default_input_props, {}, user_props or {})
end

return M
