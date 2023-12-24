local M = {}

---@param search_term string
---@param buf_id number
---@return Match?
M.highlight_matches = function(search_term, buf_id)
	vim.api.nvim_buf_clear_namespace(buf_id, -1, 0, -1) -- Clear existing highlights
	local match = nil -- Initialize the Match object

	if search_term and #search_term > 0 then
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
		local current_row, current_col = cursor_pos[1], cursor_pos[2] + 1 -- Cursor position in Lua is 1-based, and we need to convert to 0-based for indexing

		for i, line in ipairs(lines) do
			local start, finish = string.find(line, search_term)

			while start and finish do
				local hl_group = (i - 1 == current_row - 1 and start == current_col) and "IncSearch" or "Search"
				vim.api.nvim_buf_add_highlight(buf_id, -1, hl_group, i - 1, start - 1, finish)

				-- Populate the Match object if the current match corresponds to the cursor position
				if not match then
					match = {
						start_col = start - 1,
						start_row = current_row,
						end_col = finish - 1,
						end_row = current_row,
					}
				end

				start, finish = string.find(line, search_term, finish + 1)
			end
		end
	end

	return match -- Return the Match object
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

		if match then
			M.highlight_matches(search_term, original_buffer)
		end
	end

	return match
end
M.jump_to_next_match = jump_to_next_match

---@param replace_term string
---@param current_match Match
---@param buf_id number
-- a method that replaces the current match with the replace term
M.replace_current_match = function(replace_term, current_match, buf_id)
	vim.api.nvim_buf_set_text(
		buf_id,
		current_match.start_row,
		current_match.start_col,
		current_match.end_row,
		current_match.end_col,
		{}
	)

	vim.api.nvim_buf_set_text(
		buf_id,
		current_match.start_row,
		current_match.start_col,
		current_match.start_row,
		current_match.start_col,
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

return M
