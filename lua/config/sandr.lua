local dialog_manager = require("config.search-and-replace.dialog-manager")
local ns = vim.api.nvim_create_namespace("my_custom_cmdline")

local popup_options = {
	enter = false,
	focusable = true,
	border = {
		style = "rounded",
		text = {
			top = "Sandr",
			top_align = "center",
		},
	},
	relative = {
		type = "win",
	},
	position = {
		row = 4,
		col = "99%",
	},
	size = {
		width = 30,
		height = 1,
	},
}

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

local function draw_cursor(buffer, cursor_pos)
	local cursor_line = 0 -- Assuming the command line is on the first line of the buffer
	local ns_id = vim.api.nvim_create_namespace("")
	vim.api.nvim_buf_clear_namespace(buffer, ns_id, 0, -1)
	vim.api.nvim_buf_add_highlight(buffer, ns_id, "Cursor", cursor_line, cursor_pos, cursor_pos + 1)
end

local nui_popup = require("nui.popup")(popup_options)
local mounted_simple = false
local mounted_complex = false

---@param event string
---@param text string
---@param cursor_pos number
---@param prefix string
local function simple(event, text, cursor_pos, prefix)
	if event == "cmdline_show" then
		if not mounted_simple then
			nui_popup:mount()
			mounted_simple = true
			return
		else
			nui_popup:show()
		end
		local current_text = vim.api.nvim_buf_get_lines(nui_popup.bufnr, 0, -1, false)[1]
		if current_text == text then
			return
		end
		vim.api.nvim_buf_set_lines(nui_popup.bufnr, 0, -1, false, { text })
		draw_cursor(nui_popup.bufnr, cursor_pos)
		vim.schedule(function()
			nui_popup:update_layout(popup_options)
		end)
		vim.api.nvim_input(" <bs>")
	end
end

---@param event string
---@param text string
---@param cursor_pos number
---@param prefix string
local function complex(event, text, cursor_pos, prefix)
	if event == "cmdline_show" then
		if dialog_manager.get_current_text() == text and dialog_manager.get_current_cursor_pos() == cursor_pos then
			return
		end
		if not mounted_complex then
			dialog_manager.show_replace_popup(vim.api.nvim_get_current_win())
			mounted_complex = true
			return
		end
		dialog_manager.update(text, cursor_pos, prefix)
		vim.api.nvim_input(" <bs>")
	end
end

---@param event string
local function on(event, ...)
	if event == "cmdline_show" then
		local status, text, cursor_pos, prefix = pcall(parse_args, { ... })
		if not status then
			print("Error parsing args")
			return
		end
		-- simple(event, text, cursor_pos, prefix)
		vim.schedule(function()
			complex(event, text, cursor_pos, prefix)
		end)
	elseif event == "cmdline_hide" then
		print("hide")
		dialog_manager.hide_replace_popup()
		mounted_complex = false

		-- nui_popup:hide()
		-- mounted_simple = false
	end
end

vim.ui_attach(ns, { ext_cmdline = true }, on)
