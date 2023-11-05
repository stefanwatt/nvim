return {
	{
		"echasnovski/mini.extra",
		version = false,
		lazy = false,
		config = function()
			require("mini.extra").setup({})
		end,
		keys = {
			{
				"<leader>fr",
				mode = { "n" },
				function()
					MiniExtra.pickers.lsp({ scope = "references" })
				end,
				desc = "Find references",
			},
			{
				"<leader>fs",
				mode = { "n" },
				function()
					MiniExtra.pickers.lsp({ scope = "document_symbol" })
				end,
				desc = "Find symbols",
			},
			{
				"<leader>fl",
				mode = { "n" },
				function()
					MiniExtra.pickers.buf_lines({ scope = "current" })
				end,
				desc = "Find lines",
			},
			{
				"<leader>fL",
				mode = { "n" },
				function()
					MiniExtra.pickers.buf_lines({ scope = "all" })
				end,
				desc = "Find lines (global)",
			},
			{
				"<C>P",
				mode = { "n", "x" },
				function()
					MiniExtra.pickers.commands()
				end,
				desc = "Find lines (global)",
			},
			{
				"<leader>fgc",
				mode = { "n" },
				function()
					MiniExtra.pickers.git_commits()
				end,
				desc = "Find git commits",
			},
			{
				"<leader>fgb",
				mode = { "n" },
				function()
					MiniExtra.pickers.git_branches({}, {
						source = {
							name = "Git Branches",
							choose = function(item)
								print(vim.inspect(item))
								-- vim.cmd("Git switch " .. item.value)
							end,
						},
					})
				end,
				desc = "Find git branches",
			},
			{
				"<leader>fk",
				mode = { "n" },
				function()
					MiniExtra.pickers.keymaps()
				end,
				desc = "Find keymaps",
			},
			{
				"<leader>fo",
				mode = { "n" },
				function()
					MiniExtra.pickers.options()
				end,
				desc = "Find option",
			},
		},
	},
}
