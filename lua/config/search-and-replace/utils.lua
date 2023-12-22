local M = {}
-- M.highlightMatches = function(searchTerm, originalBufNr)
-- 	vim.api.nvim_buf_clear_namespace(originalBufNr, -1, 0, -1) -- Clear existing highlights
-- 	if searchTerm and #searchTerm > 0 then
-- 		vim.api.nvim_buf_clear_namespace(originalBufNr, -1, 0, -1) -- Clear existing highlights
--
-- 		local lines = vim.api.nvim_buf_get_lines(originalBufNr, 0, -1, false)
-- 		for i, line in ipairs(lines) do
-- 			local start, finish = string.find(line, searchTerm)
-- 			while start and finish do
-- 				vim.api.nvim_buf_add_highlight(originalBufNr, -1, "Search", i - 1, start - 1, finish)
-- 				start, finish = string.find(line, searchTerm, finish + 1)
-- 			end
-- 		end
-- 	else
-- 		vim.api.nvim_buf_clear_namespace(originalBufNr, -1, 0, -1) -- Clear highlights if search term is empty
-- 	end
-- end
M.highlightMatches = function(searchTerm, originalBufNr, currentMatch)
	vim.api.nvim_buf_clear_namespace(originalBufNr, -1, 0, -1) -- Clear existing highlights

	if searchTerm and #searchTerm > 0 then
		local lines = vim.api.nvim_buf_get_lines(originalBufNr, 0, -1, false)
		for i, line in ipairs(lines) do
			local start, finish = string.find(line, searchTerm)
			while start and finish do
				local hlGroup = (currentMatch and i == currentMatch.line and start == currentMatch.col) and "IncSearch"
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
local function jumpToNextMatch(searchTerm, originalBuffer, originalWindow)
	if searchTerm and #searchTerm > 0 then
		if not currentLine then
			currentLine, currentCol = unpack(vim.api.nvim_win_get_cursor(originalWindow))
		end
		local lines = vim.api.nvim_buf_get_lines(originalBuffer, 0, -1, false)

		local found = false
		local newMatch = nil
		for i = currentLine, #lines do
			if i == currentLine and currentCol >= #lines[i] then
				-- Skip the rest of the current line if cursor is at or beyond the end
				currentCol = 1
			else
				local start, _ =
					string.find(lines[i], vim.pesc(searchTerm), (i == currentLine) and (currentCol + 1) or 1)
				if start then
					newMatch = { line = i, col = start }
					currentLine, currentCol = i, start
					found = true
					break
				end
			end
		end

		if not found then
			-- Reset and start from the beginning of the file
			currentLine, currentCol = 1, 1
			for i, line in ipairs(lines) do
				local start, _ = string.find(line, vim.pesc(searchTerm), currentCol)
				if start then
					newMatch = { line = i, col = start }
					currentLine, currentCol = i, start
					break
				end
			end
		end

		if newMatch then
			M.highlightMatches(searchTerm, originalBuffer, newMatch)
		end
	end
end

M.jumpToNextMatch = jumpToNextMatch

return M
