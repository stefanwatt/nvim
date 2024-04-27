return {
	{
		"glepnir/lspsaga.nvim",
		event = "LspAttach",
		enabled = false,
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
			{
				"gD",
				mode = { "n" },
				"<cmd>Lspsaga peek_definition<CR>",
				desc = "Peek definition",
			},
			{
				"K",
				mode = { "n" },
				"<cmd>Lspsaga hover_doc()<CR>",
				desc = "Hover doc",
			},
		},
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		config = function()
			require("lspsaga").setup({
				symbol_in_winbar = { enable = false },
				ui = {
					code_action = "",
				},
			})
		end,
	},
}
