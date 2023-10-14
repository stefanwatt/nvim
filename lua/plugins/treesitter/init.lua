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
				ensure_installed = "all", -- one of "all" or a list of languages
				ignore_install = { "" }, -- List of parsers to ignore installing
				highlight = {
					enable = true, -- false will disable the whole extension
					disable = { "css" }, -- list of language that will be disabled
				},
				autotag = {
					enable = true,
				},
				indent = { enable = true, disable = { "python", "css" } },
				playground = {
					enable = true,
					disable = {},
					updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
					persist_queries = false, -- Whether the query persists across vim sessions
					keybindings = {
						toggle_query_editor = "o",
						toggle_hl_groups = "i",
						toggle_injected_languages = "t",
						toggle_anonymous_nodes = "a",
						toggle_language_display = "I",
						focus_language = "f",
						unfocus_language = "F",
						update = "R",
						goto_node = "<cr>",
						show_help = "?",
					},
				},
				context_commentstring = {
					enable = true,
				},
			})

			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					underline = true,
					virtual_text = {
						spacing = 5,
						severity_limit = "Warning",
					},
					update_in_insert = true,
				})

			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.haxe = {
				install_info = {
					url = "https://github.com/vantreeseba/tree-sitter-haxe",
					files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
					-- optional entries:
					branch = "main", -- default branch in case of git repo if different from master
				},
				filetype = "haxe", -- if filetype does not match the parser name
			}
		end,
	},
	require("plugins.treesitter.splitjoin"),
	require("plugins.treesitter.misc"),
	require("plugins.treesitter.tagalong"),
}
