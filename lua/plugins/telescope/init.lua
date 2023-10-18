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
				"<leader>ls",
				mode = { "n" },
				"<cmd>Telescope lsp_document_symbols<cr>",
				desc = "Document Symbols",
			},
			{
				"<leader>lS",
				mode = { "n" },
				"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
				desc = "Workspace Symbols",
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
			-- {
			-- 	"<leader>fb",
			-- 	mode = { "n" },
			-- 	"<cmd>Telescope buffers<cr>",
			-- 	desc = "Buffers",
			-- },
			{
				"<leader>fB",
				mode = { "n" },
				"<cmd>Telescope git_branches<cr>",
				desc = "Checkout branch",
			},
			-- {
			-- 	"<leader>ff",
			-- 	mode = { "n" },
			-- 	"<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>",
			-- 	desc = "Find files",
			-- },
			-- {
			-- 	"<leader>fw",
			-- 	mode = { "n" },
			-- 	"<cmd>Telescope live_grep<cr>",
			-- 	desc = "Find word",
			-- },
			{
				"<leader>fs",
				mode = { "n" },
				"<cmd>Telescope lsp_document_symbols<cr>",
				desc = "Find Symbols",
			},
			{
				"<leader>fh",
				mode = { "n" },
				"<cmd>Telescope help_tags<cr>",
				desc = "Help",
			},
			{
				"<leader>fr",
				mode = { "n" },
				"<cmd>Telescope lsp_references<cr>",
				desc = "References",
			},
			{
				"<leader>fk",
				mode = { "n" },
				"<cmd>Telescope keymaps<cr>",
				desc = "Keymaps",
			},
			{
				"<leader>fc",
				mode = { "n" },
				"<cmd>Telescope commands<cr>",
				desc = "Commands",
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
}
