local M = {}

M.replace_input_options = {
	enter = false,
	focusable = true,
	border = {
		style = "rounded",
		text = {
			top = "Replace",
			top_align = "center",
		},
	},
	position = {
		row = 0,
		col = "100%",
	},
	size = {
		width = 15,
		height = 1,
	},
}

return M
