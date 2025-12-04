return {
	require("plugins.lsp.cmp"),
	require("plugins.lsp.diagnostics"),
	require("plugins.lsp.go"),
	-- require("plugins.lsp.java"),
	require("plugins.lsp.lsp-config"),
	require("plugins.lsp.lsp-saga"),
	require("plugins.lsp.luasnip"),
	require("plugins.lsp.refactoring"),
	require("plugins.lsp.schemastore"),
	require("plugins.lsp.trouble"),
	require("plugins.lsp.typescript"),
	{
		"mfussenegger/nvim-jdtls",
		dependencies = {
			"neovim/nvim-lspconfig",
			"folke/which-key.nvim",
      "ray-x/lsp_signature.nvim",
			{
				"nvim-neotest/neotest",
				opts = {
					adapters = {
						["neotest-java"] = {
							-- config here
						},
					},
				},
				dependencies = {
					"nvim-neotest/nvim-nio",
					"rcasia/neotest-java",
					"nvim-lua/plenary.nvim",
					"antoinemadec/FixCursorHold.nvim",
					"nvim-treesitter/nvim-treesitter",
				},
			},
		},
	}
}
