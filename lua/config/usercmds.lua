function show_col_in_hover_window()
	local col = vim.api.nvim_eval('col(".")')
	local Popup = require("nui.popup")

	if not col then
		print("No column number found")
		return
	end
	local popup = Popup({
		position = 1,
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
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
		},
	})
	popup:map("n", "q", function()
		popup:unmount()
	end, {}, false)
	popup:mount()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { tostring(col) })
end

vim.api.nvim_create_user_command("Col", "lua show_col_in_hover_window()", {
	nargs = 0,
})
