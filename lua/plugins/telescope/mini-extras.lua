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
								local branch = item:match("%s+(%S+)%s+")
								vim.fn.jobstart({ "git", "switch", branch }, {
									stdout_buffered = true,
									stderr_buffered = true,
									on_stdout = function(_, data)
										print("checked out " .. branch)
									end,
									on_stderr = function(_, data)
										print("failed to check out " .. branch)
										print(vim.inspect(data))
									end,
								})
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
