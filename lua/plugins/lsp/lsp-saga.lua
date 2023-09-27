return {
	{
		"glepnir/lspsaga.nvim",
		event = "LspAttach",
		keys = {
			{
				"<leader>la",
				mode = { "n" },
				"<cmd>Lspsaga code_action<CR>",
				desc = "Code Action",
			},
			{
				"<leader>ld",
				mode = { "n" },
				"<cmd>Lspsaga show_line_diagnostics<CR>",
				desc = "Diagnostics",
			},
			{
				"<leader>lF",
				mode = { "n" },
				"<cmd>Lspsaga lsp_finder<CR>",
				desc = "LSP finder",
			},
			{
				"<leader>lr",
				mode = { "n" },
				"<cmd>Lspsaga rename<CR>",
				desc = "Rename",
			},
		},
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		config = function()
			require("lspsaga").setup({})
			local keymap = vim.keymap.set
			local opts = { silent = true }
			keymap("n", "gD", "<cmd>Lspsaga peek_definition<CR>", opts)
			keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
			keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
		end,
	},
}
