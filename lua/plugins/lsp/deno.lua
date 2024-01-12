require("lsp-zero").use("denols", {
	filetypes = { "typescript" },
	init_options = {
		enable = true,
		unstable = true,
		-- importMap = "/home/stefan/Projects/LeafLinkerBackend/supabase/functions/import_map.json",
		importMap = "./supabase/functions/import_map.json",
	},
	root_dir = require("lspconfig").util.root_pattern("deno.json"),
})
