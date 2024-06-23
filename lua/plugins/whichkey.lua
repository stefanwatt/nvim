return {
	{
		"folke/which-key.nvim",
		lazy = false,
		-- enabled = false,
		opts = {
			plugins = { spelling = true },
			defaults = {
				mode = { "n" },
				["<leader>v"] = { "<cmd>vsplit<cr>", "vsplit" },
				["<leader>H"] = { "<cmd>nohlsearch<CR>", "no highlights" },
				["<leader><leader>p"] = { "Print" },
				["<leader><leader>pw"] = { "<cmd>lua print(vim.api.nvim_get_current_win())<CR>", "Current window id" },
				["<leader><leader>pb"] = { "<cmd>lua print(vim.api.nvim_get_current_buf())<CR>", "Current buffer id" },
				["<leader><leader>pft"] = {
					"<cmd>lua print(vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(0), 'buftype'))<CR>",
					"Current buffer type",
				},
			},
		},
	},
}
