return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				denols = {
					filetypes = { "typescript" },
					init_options = {
						enable = true,
						unstable = true,
						-- importMap = "/home/stefan/Projects/LeafLinkerBackend/supabase/functions/import_map.json",
						importMap = "./supabase/functions/import_map.json",
					},
					root_dir = require("lspconfig").util.root_pattern("deno.json"),
				},
				pyright = {},
				angularls = {},
				astro = {},
				bashls = {},
				cssls = {},
				eslint = {},
				emmet_ls = {},
				html = {},
				jsonls = {},
				lua_ls = {
					mason = false, -- set to false if you don't want this server to be installed with mason
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				marksman = {},
				nil_ls = {},
				sqlls = {},
				svelte = {},
				tailwindcss = {},
				vimls = {},
				lemminx = {},
				yamlls = {},
				rust_analyzer = {},
			},
		},
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
		},
	},
}
