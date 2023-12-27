local utils = require("config.utils")
---
---@class Match
---@field start_col number
---@field start_row number
---@field end_row number
---@field end_col number
---@field index number
---

local M = {}

---@param search_term string
---@param buf_id number
---@return table<Match>
function M.get_matches(search_term, buf_id)
	local matches = {}

	if search_term and #search_term > 0 then
		local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
		local index = 1

		for i, line in ipairs(lines) do
			local start, finish = string.find(line, search_term)

			while start and finish do
				local match = {
					start_col = start - 1,
					start_row = i,
					end_col = finish,
					end_row = i,
					index = index,
				}
				index = index + 1
				table.insert(matches, match)
				start, finish = string.find(line, search_term, finish + 1)
			end
		end
	end

	return matches
end

M.is_match_in_viewport = function(match, winid)
	local win_top = vim.api.nvim_win_get_cursor(winid)[1]
	local win_bot = vim.api.nvim_win_get_height(winid) + win_top
	return match.start_row >= win_top and match.end_row <= win_bot
end

---@param matches table<Match>
M.get_closest_match_after_cursor = function(matches, win_id)
	local closest_match = nil
	local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(win_id))
	for _, match in ipairs(matches) do
		local on_line_after = match.start_row > cursor_row
		local on_same_line = match.start_row == cursor_row
		local cursor_on_match = on_same_line and match.start_col <= cursor_col and match.end_col >= cursor_col
		local on_same_line_after = not cursor_on_match and on_same_line and match.start_col >= cursor_col
		if on_line_after or cursor_on_match or on_same_line_after then
			return match
		end
	end
end

---@param replace_term string
---@param current_match Match
---@param buf_id number
M.replace_current_match = function(replace_term, current_match, buf_id)
	vim.api.nvim_buf_set_text(
		buf_id,
		current_match.start_row - 1,
		current_match.start_col,
		current_match.end_row - 1,
		current_match.end_col,
		{ replace_term }
	)
end

M.equals = function(match1, match2)
	return match1.start_col == match2.start_col
		and match1.start_row == match2.start_row
		and match1.end_col == match2.end_col
		and match1.end_row == match2.end_row
end

---@param current_match Match
---@param matches Match[]
M.get_next_match = function(current_match, matches)
	if current_match == nil then
		print("must provide value for current_match")
		return
	end

	local current_index = utils.index_of(table, function(match)
		return M.equals(match, current_match)
	end)
	if current_index == nil then
		print("couldnt locate match in list of matches")
		return
	end
	return current_index + 1 > matches and matches[1] or matches[current_index + 1]
end

return M
