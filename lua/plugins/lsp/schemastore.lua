return {
	"b0o/schemastore.nvim",
	dependencies = { "neovim/nvim-lspconfig" },
	event = "VeryLazy",
	version = false,
	config = function()
		local lspconfig = require("lspconfig")
		local schemastore = require("schemastore")
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		lspconfig.jsonls.setup({
			capabilities = capabilities,
			settings = {
				json = {
					schemas = schemastore.json.schemas(),
					validate = { enable = true },
				},
			},
		})
		lspconfig.yamlls.setup({
			settings = {
				yaml = {
					schemaStore = {
						-- You must disable built-in schemaStore support if you want to use
						-- this plugin and its advanced options like `ignore`.
						enable = false,
						-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
						url = "",
					},
					schemas = schemastore.yaml.schemas(),
				},
			},
		})
	end,
}
