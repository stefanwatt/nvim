local merge_tables = require("config.utils").merge_tables
local M = {}

local SEARCH_DIALOG_TITLE = "Search"
local SEARCH_DIALOG_ROW = 1
local REPLACE_DIALOG_TITLE = "Replace"
local REPLACE_DIALOG_ROW = 3

---@param title string
---@param row number
---@return nui_popup_options
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

---@return nui_popup_options
M.get_search_dialog_popup_options = function()
	return get_popup_options(SEARCH_DIALOG_TITLE, SEARCH_DIALOG_ROW)
end

---@return nui_popup_options
M.get_replace_dialog_popup_options = function()
	return get_popup_options(REPLACE_DIALOG_TITLE, REPLACE_DIALOG_ROW)
end
return M
