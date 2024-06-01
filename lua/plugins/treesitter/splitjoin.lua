return {
	{
		"Wansmer/treesj",
		event = "VeryLazy",
		keys = {
			{
				"<space>bj",
				"<cmd>TSJJoin",
				desc = "Block Join",
			},
			{
				"<space>bs",
				"<cmd>TSJJoin",
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
