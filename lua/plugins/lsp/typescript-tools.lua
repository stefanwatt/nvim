return {
	"pmizio/typescript-tools.nvim",
	config = function()
		local lsp_zero = require("lsp-zero")
		lsp_zero.extend_lspconfig()
		require("typescript-tools").setup({
			on_attach = function(bufnr) end,
			settings = {
				separate_diagnostic_server = true,
				publish_diagnostic_on = "insert_leave",
				tsserver_path = os.getenv("TSSERVER"),
				tsserver_plugins = {},
				tsserver_file_preferences = {
					includeInlayParameterNameHints = "all",
					includeCompletionsForModuleExports = true,
					quotePreference = "auto",
				},
				tsserver_format_options = {
					allowIncompleteCompletions = false,
					allowRenameOfImportPath = false,
				},
			},
		})
	end,
}
