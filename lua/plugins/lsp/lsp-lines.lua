return {
	{
		"stefanwatt/lsp-lines.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>lv",
				mode = { "n" },
				"<cmd>lua require('lsp_lines').toggle()<cr>",
				desc = "Toggle Virtual Text",
			},
		},
		config = function()
			require("lsp_lines").setup()
			vim.diagnostic.config({
				virtual_text = false,
			})
			vim.diagnostic.config({ virtual_lines = false })
		end,
	},
}
