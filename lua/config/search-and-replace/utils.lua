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

---@param match Match
---@param buf_id number
---@param hl_group string
function M.apply_highlight(match, buf_id, hl_group)
	if match then
		vim.api.nvim_buf_add_highlight(buf_id, -1, hl_group, match.start_row - 1, match.start_col, match.end_col)
	end
end

local current_line, current_col

---@param search_term string
---@param original_buffer number
---@param original_window number
---@return Match
local function jump_to_next_match(search_term, original_buffer, original_window)
	local match = nil

	if search_term and #search_term > 0 then
		local current_line, current_col = unpack(vim.api.nvim_win_get_cursor(original_window))
		local rows = vim.api.nvim_buf_get_lines(original_buffer, 0, -1, false)

		local found = false

		for i = current_line, #rows do
			local line = rows[i]
			local start, _ = string.find(line, vim.pesc(search_term), (i == current_line) and (current_col + 1) or 1)

			if start then
				local end_col = start + #search_term - 1
				match = {
					start_col = start,
					start_row = i,
					end_col = end_col,
					end_row = i,
				}
				current_line, current_col = i, end_col + 1
				found = true
				break
			end
		end

		if not found then
			current_line, current_col = 1, 0
			for i, line in ipairs(rows) do
				local start, _ = string.find(line, vim.pesc(search_term), current_col + 1)

				if start then
					local end_col = start + #search_term - 1
					match = {
						start_col = start,
						start_row = i,
						end_col = end_col,
						end_row = i,
					}
					current_line, current_col = i, end_col
					break
				end
			end
		end
	end
	return match
end
M.get_next_match = jump_to_next_match

---@param replace_term string
---@param current_match Match
---@param buf_id number
-- a method that replaces the current match with the replace term
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

---@param search_term string
---@param replace_term string
---@param buf_id number
M.replace_all = function(search_term, replace_term, buf_id)
	local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)

	for i, line in ipairs(lines) do
		lines[i] = line:gsub(search_term, replace_term)
	end

	vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
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
return M
