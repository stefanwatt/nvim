return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"windwp/nvim-ts-autotag",
		},
		event = "BufReadPost",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = {
					"css",
					"diff",
					"git_config",
					"git_rebase",
					"gitattributes",
					"gitcommit",
					"gitignore",
					"go",
					"gomod",
					"html",
					"javascript",
					"jsdoc",
					"json",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"nix",
					"svelte",
					"templ",
					"toml",
					"typescript",
					"vim",
					"vimdoc",
					"xml",
					"yaml",
				},
				ignore_install = { "" }, -- List of parsers to ignore installing
				highlight = {
					enable = true, -- false will disable the whole extension
				},
				autotag = {
					enable = true,
				},
				indent = { enable = true },
			})

			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					underline = true,
					virtual_text = {
						spacing = 5,
					},
					update_in_insert = true,
				})
		end,
	},
	require("plugins.treesitter.splitjoin"),
	require("plugins.treesitter.misc"),
	require("plugins.treesitter.tagalong"),
}
