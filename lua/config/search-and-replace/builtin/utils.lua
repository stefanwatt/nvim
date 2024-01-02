local M = {}

---@param cmd string
M.execute_cmd = function(cmd)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "i", true)
end

---@return string?
M.get_cmd_line = function()
	local cmdline = vim.fn.getcmdline()
	if not M.is_substitute_command() then
		return
	end
	return cmdline
end

---@return boolean?
M.is_substitute_command = function()
	local cmdline = vim.fn.getcmdline()
	if not cmdline or cmdline == "" then
		return
	end
	local pattern = "^%%?s/.*/.*/[gci]*$"
	return string.match(cmdline, pattern) ~= nil
end

---@param _cmdline? string
---@return number?, number?, number?
M.get_slash_positions = function(_cmdline)
	local cmdline = _cmdline or M.get_cmd_line()
	if not cmdline then
		return
	end
	local first_slash_pos, second_slash_pos = cmdline:find("/"), cmdline:find("/", cmdline:find("/") + 1)
	if not second_slash_pos then
		return
	end
	local third_slash_pos = string.find(cmdline, "/", second_slash_pos + 1)
	return first_slash_pos, second_slash_pos, third_slash_pos
end

---@return "search" | "replace"  | "end" | nil
M.cursor_pos_in_subst_cmd = function()
	local cmdline = M.get_cmd_line()
	if not cmdline then
		return nil
	end
	local cursor_pos = vim.fn.getcmdpos()
	local first_slash_pos, second_slash_pos, third_slash_pos = M.get_slash_positions(cmdline)

	if not first_slash_pos or not second_slash_pos then
		return nil
	end

	if cursor_pos > first_slash_pos and cursor_pos <= second_slash_pos then
		return "search"
	elseif third_slash_pos and cursor_pos > second_slash_pos and cursor_pos <= third_slash_pos then
		return "replace"
	elseif third_slash_pos and cursor_pos > third_slash_pos then
		return "end"
	else
		return nil
	end
end

return M
