local M = {}

M.getSubDirectories = function(dirname)
	local dir = io.popen("ls " .. dirname)
	local subdirectories = {}
	for name in dir:lines() do
		table.insert(subdirectories, name)
	end
	return subdirectories
end

M.get_buf_text = function()
	local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
	return table.concat(content, "\n")
end

return M
