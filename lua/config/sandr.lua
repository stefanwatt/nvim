local dialog_manager = require("config.search-and-replace.dialog-manager")
local ns = vim.api.nvim_create_namespace("my_custom_cmdline")
--- @param args table: The unstructured argument list.
--- @return string: text
--- @return number: cursor_pos
--- @return string: prefix
local function parse_args(args)
	local text = args[1][1][2]
	local cursor_pos = args[2]
	local prefix = args[3]
	return text, cursor_pos, prefix
end
local is_substitute_command = function()
	local cmdline = vim.fn.getcmdline()
	if not cmdline or cmdline == "" then
		return
	end
	local pattern = "^%%?s/.*/.*/[gci]*$"
	return string.match(cmdline, pattern) ~= nil
end
local visible = false
---@param event string
local function on(event, ...)
	if event == "cmdline_show" then
		local text, cursor_pos, prefix = parse_args({ ... })
		if prefix ~= ":" or not is_substitute_command() then
			print(text)
			return
		end
		if not visible then
			dialog_manager.toggle_replace_popup(vim.api.nvim_get_current_win())
			visible = true
		end
		dialog_manager.update(text, cursor_pos, prefix)
	elseif event == "cmdline_hide" then
		-- dialog_manager.hide_replace_popup()
		visible = false
	end
end

vim.ui_attach(ns, { ext_cmdline = true }, on)
