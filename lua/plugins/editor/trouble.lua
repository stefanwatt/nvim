return {
	"folke/trouble.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>tt",
			mode = { "n" },
			"<CMD>Trouble<CR>",
			desc = "Toggle Trouble",
		},
		{
			"<leader>tf",
			mode = { "n" },
			"<CMD>TodoTelescope<CR>",
			desc = "Find TODOs",
		},
	},
}
