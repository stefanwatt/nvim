local M = {}

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

---@param table table
---@param cb function(value: any): boolean
M.index_of = function(table, cb)
	for index, value in ipairs(table) do
		if cb(value) then
			return index
		end
	end
	return nil
end

M.merge_tables = function(...)
	local tables = { ... }
	local result = {}

	for _, tbl in ipairs(tables) do
		if type(tbl) == "table" then
			for key, value in pairs(tbl) do
				result[key] = value
			end
		end
	end

	return result
end

M.buf_vtext = function()
	local a_orig = vim.fn.getreg("a")
	local mode = vim.fn.mode()
	if mode ~= "v" and mode ~= "V" then
		vim.cmd([[normal! gv]])
	end
	vim.cmd([[silent! normal! "aygv]])
	local text = vim.fn.getreg("a")
	vim.fn.setreg("a", a_orig)
	return tostring(text)
end
return M
