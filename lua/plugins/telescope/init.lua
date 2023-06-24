return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-file-browser.nvim",
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
}
