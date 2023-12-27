local match_equals = require("config.search-and-replace.match").equals
local HL_GROUP_DEFAULT = "Search"
local HL_GROUP_CURRENT_MATCH = "IncSearch"

local M = {}
---@param match Match
---@param buf_id number
---@param hl_group string
function M.apply_highlight(match, buf_id, hl_group)
	if match then
		vim.api.nvim_buf_add_highlight(buf_id, -1, hl_group, match.start_row - 1, match.start_col, match.end_col)
	end
end

---@param matches Match[]
---
M.highlight_matches = function(matches, current_match, buf_id)
	vim.api.nvim_buf_clear_namespace(buf_id, -1, 0, -1)
	for _, match in ipairs(matches) do
		local hl_group = match_equals(match, current_match) and HL_GROUP_CURRENT_MATCH or HL_GROUP_DEFAULT
		M.apply_highlight(match, buf_id, hl_group)
	end
end

return M
