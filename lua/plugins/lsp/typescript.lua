return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"neovim/nvim-lspconfig",
			"kyoh86/climbdir.nvim",
		},
		-- enabled = false,
		opts = {},
		keys = {
			{
				"<leader>lo",
				"<cmd>TSToolsAddMissingImports<cr><cmd>TSToolsRemoveUnusedImports<cr>",
				desc = "[l]sp [o]rganize imports",
			},
		},
		event = "VeryLazy",
		config = function()
			vim.keymap.set({ "n", "x", "v" }, "<leader>la", vim.lsp.buf.code_action, { silent = true })
			require("typescript-tools").setup({
				on_attach = function(bufnr) end,
				single_file_support = true,
				settings = {
					separate_diagnostic_server = true,
					publish_diagnostic_on = "insert_leave",
					tsserver_path = os.getenv("TSSERVER"),
					tsserver_plugins = {},
					tsserver_file_preferences = {
						includeInlayParameterNameHints = "none",
						includeCompletionsForModuleExports = true,
						quotePreference = "auto",
						includePackageJsonAutoImports = "off",
					},
					tsserver_format_options = {
						allowIncompleteCompletions = false,
						allowRenameOfImportPath = false,
					},
				},
				-- root_dir = function(path)
				-- 	local marker = require("climbdir.marker")
				-- 	return require("climbdir").climb(path,
				-- 		marker.one_of(marker.has_readable_file("package.json"), marker.has_directory("node_modules")), {
				-- 			halt = marker.one_of(
				-- 				marker.has_readable_file("deno.json"),
				-- 				marker.has_readable_file("deno.jsonc"),
				-- 				marker.has_readable_file("import_map.json"),
				-- 				marker.has_directory("denops")
				-- 			),
				-- 		})
				-- end,
			})
		end,
	},
}
