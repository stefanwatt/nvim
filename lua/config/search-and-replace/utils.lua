local M = {}
M.highlightMatches = function(searchTerm, originalBufNr, currentMatch)
	vim.api.nvim_buf_clear_namespace(originalBufNr, -1, 0, -1) -- Clear existing highlights

	if searchTerm and #searchTerm > 0 then
		local lines = vim.api.nvim_buf_get_lines(originalBufNr, 0, -1, false)
		for i, line in ipairs(lines) do
			local start, finish = string.find(line, searchTerm)
			while start and finish do
				local hlGroup = (currentMatch and i == currentMatch.row and start == currentMatch.col) and "IncSearch"
					or "Search"
				vim.api.nvim_buf_add_highlight(originalBufNr, -1, hlGroup, i - 1, start - 1, finish)
				start, finish = string.find(line, searchTerm, finish + 1)
			end
		end
	end
end

M.searchAndReplace = function(searchTerm, replaceTerm)
	local currentBuffer = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(currentBuffer, 0, -1, false)

	for i, line in ipairs(lines) do
		lines[i] = line:gsub(searchTerm, replaceTerm)
	end

	vim.api.nvim_buf_set_lines(currentBuffer, 0, -1, false, lines)
end

local currentLine, currentCol

---@return table {row: integer, col: integer}
local function jumpToNextMatch(searchTerm, originalBuffer, originalWindow)
	local new_match = nil
	if searchTerm and #searchTerm > 0 then
		if not currentLine then
			currentLine, currentCol = unpack(vim.api.nvim_win_get_cursor(originalWindow))
		end
		local rows = vim.api.nvim_buf_get_lines(originalBuffer, 0, -1, false)

		local found = false
		for i = currentLine, #rows do
			if i == currentLine and currentCol >= #rows[i] then
				-- Skip the rest of the current line if cursor is at or beyond the end
				currentCol = 1
			else
				local start, _ =
					string.find(rows[i], vim.pesc(searchTerm), (i == currentLine) and (currentCol + 1) or 1)
				if start then
					new_match = { row = i, col = start }
					currentLine, currentCol = i, start
					found = true
					break
				end
			end
		end

		if not found then
			-- Reset and start from the beginning of the file
			currentLine, currentCol = 1, 1
			for i, line in ipairs(rows) do
				local start, _ = string.find(line, vim.pesc(searchTerm), currentCol)
				if start then
					new_match = { line = i, col = start }
					currentLine, currentCol = i, start
					break
				end
			end
		end

		if new_match then
			M.highlightMatches(searchTerm, originalBuffer, new_match)
		end
	end
	return new_match
end

M.jumpToNextMatch = jumpToNextMatch

M.replace_current_match = function() end

return M
