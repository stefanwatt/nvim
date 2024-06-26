return {
	"GustavoKatel/tasks.nvim",
	event = "VeryLazy",
	commit = "1bb8b9725cc7bb58e646d9a8da48a57010cafcad",
	keys = {
		{
			"<leader>ft",
			name = "Tasks",
		},
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
	enabled = false,
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"elianiva/telescope-npm.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("telescope").load_extension("tasks")
		local tasks = require("tasks")
		local source_npm = require("tasks.sources.npm")
		local source_tasksjson = require("tasks.sources.tasksjson")

		local builtin = require("tasks.sources.builtin")

		tasks.setup({
			sources = {
				npm = source_npm,
				vscode = source_tasksjson,
				utils = builtin.new_builtin_source({
					npm_install = {
						cmd = "npm install",
					},
					tsc_watch = {
						cmd = "tsc -w",
					},
				}),
			},
		})
	end,
}
