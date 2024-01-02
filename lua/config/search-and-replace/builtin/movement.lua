local utils = require("config.search-and-replace.builtin.utils")
local state = require("config.search-and-replace.builtin.state")
local M = {}

M.from_replace_to_search = function()
	local cmdline = utils.get_cmd_line()
	if not cmdline then
		return nil
	end
	local first_slash_pos, second_slash_pos, third_slash_pos = utils.get_slash_positions(cmdline)
	if not first_slash_pos or not second_slash_pos or not third_slash_pos then
		return
	end

	local cursor_pos = vim.fn.getcmdpos()
	local left_presses_needed_to_second_slash = cursor_pos - second_slash_pos
	local cmd = string.rep("<Left>", left_presses_needed_to_second_slash)

	local search_term = cmdline:sub(first_slash_pos + 1, second_slash_pos - 1)
	cmd = cmd .. string.rep("<BS>", #search_term)
	utils.execute_cmd(cmd)

	if search_term ~= "" then
		state.last_search_term = search_term
	end
end

M.from_end_to_replace = function()
	local cmdline = utils.get_cmd_line()
	if not cmdline then
		return nil
	end
	local first_slash_pos, second_slash_pos, third_slash_pos = utils.get_slash_positions(cmdline)
	if not first_slash_pos or not second_slash_pos or not third_slash_pos then
		return
	end

	local cursor_pos = vim.fn.getcmdpos()
	local left_presses_needed_to_third_slash = cursor_pos - third_slash_pos
	local cmd = string.rep("<Left>", left_presses_needed_to_third_slash)

	local replace_term = cmdline:sub(second_slash_pos + 1, third_slash_pos - 1)
	cmd = cmd .. string.rep("<BS>", #replace_term)
	utils.execute_cmd(cmd)
	if replace_term ~= "" then
		state.last_replace_term = replace_term
	end
end

M.from_search_to_replace = function()
	local cmdline = utils.get_cmd_line()
	if not cmdline then
		return nil
	end
	local first_slash_pos, second_slash_pos, third_slash_pos = utils.get_slash_positions(cmdline)
	if not first_slash_pos or not second_slash_pos or not third_slash_pos then
		return
	end
	local search_term = cmdline:sub(first_slash_pos + 1, second_slash_pos - 1)
	local cmd = ""
	if search_term == "" and state.last_search_term and state.last_search_term ~= "" then
		cmd = cmd .. state.last_search_term
	end
	local cursor_pos = vim.fn.getcmdpos()
	local right_presses_needed_to_third_slash = third_slash_pos - cursor_pos
	cmd = cmd .. string.rep("<Right>", right_presses_needed_to_third_slash)

	local replace_term = cmdline:sub(second_slash_pos + 1, third_slash_pos - 1)
	cmd = cmd .. string.rep("<BS>", #replace_term)

	utils.execute_cmd(cmd)
	if search_term ~= "" then
		state.last_search_term = search_term
	end
	if replace_term ~= "" then
		state.last_replace_term = replace_term
	end
end

M.from_replace_to_end = function()
	local cmdline = utils.get_cmd_line()
	if not cmdline then
		return nil
	end
	local first_slash_pos, second_slash_pos, third_slash_pos = utils.get_slash_positions(cmdline)
	local cursor_pos = vim.fn.getcmdpos()
	local right_presses_needed_to_third_slash = third_slash_pos - cursor_pos
	local replace_term = cmdline:sub(second_slash_pos + 1, third_slash_pos - 1)
	local cmd = string.rep("<Right>", right_presses_needed_to_third_slash)
	if replace_term == "" and state.last_replace_term and state.last_replace_term ~= "" then
		cmd = cmd .. state.last_replace_term
	end
	cursor_pos = vim.fn.getcmdpos()
	local right_presses_needed_to_end = #cmdline - cursor_pos + 1
	cmd = cmd .. string.rep("<Right>", right_presses_needed_to_end)
	utils.execute_cmd(cmd)
	if replace_term ~= "" then
		state.last_replace_term = replace_term
	end
end

return M
