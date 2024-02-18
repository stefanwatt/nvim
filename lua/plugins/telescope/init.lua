return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{
				"<leader>f",
				name = "Find",
			},
			{
				"<leader>/",
				false,
			},
			{
				"<leader>fr",
				false,
			},
			{
				"<leader>fd",
				mode = { "n" },
				"<cmd>lua require('telescope').extensions.diff.diff_current({ hidden = true })<cr>",
				desc = "Buffers",
			},
			{
				"<leader>fD",
				mode = { "n" },
				"<cmd>lua require('telescope').extensions.diff.diff_files({ hidden = true })<cr>",
				desc = "Buffers",
			},
			{
				"<leader>ft",
				mode = { "n" },
				name = "Tasks",
				keys = {
					{
						"<leader>fts",
						mode = { "n" },
						"<cmd>Telescope tasks specs<cr>",
						desc = "Specs",
					},
					{
						"<leader>ftr",
						mode = { "n" },
						"<cmd>Telescope tasks running<cr>",
						desc = "Running",
					},
				},
			},
			{
				"<leader>fp",
				mode = { "n" },
				"<cmd>Telescope projects<cr>",
				desc = "Keymaps",
			},
		},
		cmd = "Telescope",
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					path_display = { "smart" },
					file_ignore_patterns = { ".git/", "node_modules" },
					mappings = {
						i = {
							["<Down>"] = actions.move_selection_next,
							["<Up>"] = actions.move_selection_previous,
							["<C-Down>"] = actions.cycle_history_next,
							["<C-Up>"] = actions.cycle_history_prev,
						},
					},
				},
			})
		end,
	},
	require("plugins.telescope.npm"),
	require("plugins.telescope.projects"),
	require("plugins.telescope.diff"),
	require("plugins.telescope.mini-extras"),
}
