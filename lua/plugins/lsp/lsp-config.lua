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
				lua_ls = {},
				marksman = {},
				sqlls = {},
				svelte = {},
				tailwindcss = {},
				vimls = {},
				lemminx = {},
				yamlls = {},
				rust_analyzer = {},
			},
		},
	},
}
