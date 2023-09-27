return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
		config = function()
			vim.keymap.set({ "n", "x", "v" }, "<leader>la", vim.lsp.buf.code_action, { silent = true })
			require("typescript-tools").setup({
				on_attach = function(bufnr) end,
				settings = {
					separate_diagnostic_server = true,
					publish_diagnostic_on = "insert_leave",
          tsserver_path = "/run/current-system/sw/bin/tsserver",
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
	},
}
