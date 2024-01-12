return {
	"VonHeikemen/lsp-zero.nvim",
	branch = "v3.x",
	dependencies = {
		"folke/neodev.nvim",
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"b0o/SchemaStore.nvim",
		"pmizio/typescript-tools.nvim",
		"nvim-lua/plenary.nvim",
	},
	event = "VeryLazy",
	config = function()
		local lsp_zero = require("lsp-zero")
		lsp_zero.extend_lspconfig()
		require("plugins.lsp.typescript-tools")
		require("plugins.lsp.schemastore")
		lsp_zero.on_attach(function(_, bufnr)
			lsp_zero.default_keymaps({ buffer = bufnr })
		end)
		require("mason").setup({})
		require("mason-lspconfig").setup({
			ensure_installed = { "cssls", "eslint", "html", "svelte", "tailwindcss", "vimls" },
			handlers = {
				lsp_zero.default_setup,
			},
		})
		require("plugins.lsp.cmp")
	end,
	keys = {
		{
			"<leader>lR",
			mode = { "n" },
			"<cmd>lua vim.lsp.buf.references()<cr>",
			desc = "References",
		},
		{
			"<leader>ll",
			mode = { "n" },
			"<cmd>lua vim.diagnostic.config({ virtual_lines = { only_current_line = true } })<cr>",
			desc = "Virtual Text current line",
		},
		{
			"<leader>lo",
			mode = { "n" },
			"<cmd>LSoutlineToggle<CR>",
			desc = "Toggle Outline",
		},
		{
			"<leader>lI",
			mode = { "n" },
			"<cmd>Mason<cr>",
			desc = "Installer Info",
		},
		{
			"<leader>li",
			mode = { "n" },
			"<cmd>LspInfo<cr>",
			desc = "Info",
		},
		{
			"<leader>lh",
			mode = { "n" },
			"<cmd>IlluminationToggle<cr>",
			desc = "Toggle Doc HL",
		},
		{
			"<leader>lf",
			mode = { "n" },
			"<cmd>lua vim.lsp.buf.format()<cr>",
			desc = "Format",
		},
		{
			"<leader>lr",
			mode = { "n" },
			"<cmd>lua vim.lsp.buf.rename()<cr>",
			desc = "LSP rename",
		},
	},
}
