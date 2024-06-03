return {
	"folke/trouble.nvim",
	event = "VeryLazy",
	opts = {
		focus = true,
		auto_preview = false,
		preview = {
			buf_options = {
				modifiable = true,
				readonly = false,
			},
			enter = true,
			type = "float",
			relative = "editor",
			size = {
				width = 0.8,
				height = 0.8,
			},
			position = { 5, 5 },
			border = "rounded",
			focusable = true,
			title = "Trouble - Preview",
			title_pos = "center",
		},
	},
	keys = {
		{
			"<leader>tw",
			mode = { "n" },
			"<CMD>Trouble diagnostics toggle<CR>",
			desc = "Workspace diagnostics",
		},
		{
			"<leader>tb",
			mode = { "n" },
			"<CMD>Trouble diagnostics toggle filter.buf=0<CR>",
			desc = "Buffer diagnostics",
		},
		{
			"<leader>tf",
			mode = { "n" },
			"<CMD>TodoTelescope<CR>",
			desc = "Find TODOs",
		},
	},
}
