vim.api.nvim_create_user_command("ToggleFormatOnSave", function(args)
	vim.g.disable_autoformat = not vim.g.disable_autoformat
end, {
	desc = "Toggle autoformat-on-save",
	bang = true,
})

function show_col_in_hover_window()
	vim.cmd("highlight InvisibleCursor guibg=bg guifg=bg")
	local col = vim.api.nvim_eval('col(".")')
	local Popup = require("nui.popup")

	local originalWinNr = vim.api.nvim_get_current_win()
	if not col then
		print("No column number found")
		return
	end
	local popup = Popup({
		position = {
			row = 0,
			col = 2,
		},
		size = {
			width = 3,
			height = 1,
		},
		enter = true,
		focusable = true,
		zindex = 50,
		relative = "cursor",
		border = {
			padding = {
				top = 0,
				bottom = 0,
				left = 0,
				right = 0,
			},
			style = "rounded",
		},
		buf_options = {
			modifiable = true,
			readonly = false,
		},
		win_options = {
			winblend = 10,
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder,Cursor:InvisibleCursor",
		},
	})
	popup:map("n", "q", function()
		popup:unmount()
	end, {}, false)
	popup:mount()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { tostring(col) })
	-- vim.api.nvim_set_current_win(originalWinNr)
end

vim.api.nvim_create_user_command("Col", "lua show_col_in_hover_window()", {
	nargs = 0,
})

vim.api.nvim_create_user_command("NvimGui", function(args)
	local command = "/home/stefan/Projects/spectre-gui/build/bin/spectre-gui"
	local flags = {
		{ name = "mode",       value = "buffer" },
		{ name = "servername", value = vim.v.servername },
	}
	require("config.utils").i3_exec(command, flags)
end, { nargs = "*" })

local function capture_highlights_to_new_buffer()
	local hl_output = vim.api.nvim_exec('silent! highlight', true)

	vim.cmd('enew')

	vim.bo.buftype = 'nofile'
	vim.bo.bufhidden = 'wipe'
	vim.bo.swapfile = false
	vim.bo.filetype = 'diff' 

	local lines = vim.split(hl_output, '\n')
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

	for _, line in ipairs(lines) do
		if line:match("^%s*hi%s+") then
			vim.api.nvim_command(line)
		end
	end
end

vim.api.nvim_create_user_command("Highlight", capture_highlights_to_new_buffer, { nargs = 0 })
