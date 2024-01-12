return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"folke/neodev.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"b0o/SchemaStore.nvim",
		"nvim-lua/plenary.nvim",
		"pmizio/typescript-tools.nvim",
	},
	event = "VeryLazy",
	config = function()
		require("neodev").setup()
		local servers = { "cssls", "eslint", "html", "svelte", "tailwindcss", "vimls" }
		require("mason").setup({})
		require("mason-lspconfig").setup({
			ensure_installed = servers,
			automatic_installation = true,
		})
		require("plugins.lsp.cmp")
		local lspconfig = require("lspconfig")

		lspconfig.lua_ls.setup({
			mason = false,
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})
		lspconfig.denols.setup({
			filetypes = { "typescript" },
			init_options = {
				enable = true,
				unstable = true,
				-- importMap = "/home/stefan/Projects/LeafLinkerBackend/supabase/functions/import_map.json",
				importMap = "./supabase/functions/import_map.json",
			},
			root_dir = require("lspconfig").util.root_pattern("deno.json"),
		})
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		for _, server in ipairs(servers) do
			lspconfig[server].setup({
				capabilities = capabilities,
			})
		end
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
