return {
	{
		"Wansmer/treesj",
		event = "VeryLazy",
		keys = {
			{
				"<leader>j",
				"<cmd>TSJJoin<cr>",
				desc = "Block Join",
			},
			{
				"<leader>s",
				"<cmd>TSJSplit<cr>",
				desc = "Block Split",
			},
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({
				use_default_keymaps = false,
				max_join_length = 999,
			})
		end,
	},
}
