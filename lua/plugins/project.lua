return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"ahmedkhalf/project.nvim",
			opts = {
				manual_mode = true,
			},
			event = "VeryLazy",
			config = function()
				require("telescope").setup({})
				require("project_nvim").setup({})
			end,
			keys = {
				{ "<leader>fp", "<Cmd>Telescope projects<CR>", desc = "Projects" },
			},
		},
	},
}
