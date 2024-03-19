return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{
				"<leader>ngg",
				mode = { "n" },
				":Neogit<CR>",
				desc = "Neogit",
			},
			{
				"<leader>ngc",
				mode = { "n" },
				":Neogit commit<CR>",
				desc = "Neogit Commit",
			},
		},
		config = true,
	},
	{
		"f-person/git-blame.nvim",
		config = function()
			require("gitblame").setup({
				enabled = false,
			})
		end,
		event = "VeryLazy",
		keys = {
			{
				"<leader>gb",
				mode = { "n" },
				":GitBlameToggle<CR>",
				desc = "Git Blame",
			},
		},
	},
}
