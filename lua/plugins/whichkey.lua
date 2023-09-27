return {
	{
		"folke/which-key.nvim",
		lazy = false,
		opts = {
			plugins = { spelling = true },
			defaults = {
				mode = { "n" },
				["<leader>v"] = { "<cmd>vsplit<cr>", "vsplit" },
				["<leader>H"] = { "<cmd>nohlsearch<CR>", "no highlights" },
			},
		},
	},
}
