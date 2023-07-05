return {
	{
		"ThePrimeagen/harpoon",
		event = "VeryLazy",
		keys = {
			{
				"<Tab>",
				mode = { "n" },
				function()
					require("harpoon.ui").nav_next()
				end,
				desc = "Harpoon next file",
			},
			{
				"<S-Tab>",
				mode = { "n" },
				function()
					require("harpoon.ui").nav_prev()
				end,
				desc = "Harpoon prev file",
			},
			{
				"<leader>ha",
				mode = { "n" },
				function()
					require("harpoon.mark").add_file()
				end,
				desc = "add file",
			},
			{
				"<leader>hm",
				mode = { "n" },
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
				desc = "menu",
			},
			{
				"<leader>htt",
				mode = { "n" },
				function()
					require("harpoon.term").gotoTerminal(1)
				end,
				desc = "Terminal 1",
			},
			{
				"<leader>ht1",
				mode = { "n" },
				function()
					require("harpoon.term").gotoTerminal(1)
				end,
				desc = "Terminal 1",
			},
			{
				"<leader>ht2",
				mode = { "n" },
				function()
					require("harpoon.term").gotoTerminal(2)
				end,
				desc = "Terminal 2",
			},
			{
				"<leader>ht3",
				mode = { "n" },
				function()
					require("harpoon.term").gotoTerminal(3)
				end,
				desc = "Terminal 3",
			},
			{
				"<leader>ht4",
				mode = { "n" },
				function()
					require("harpoon.term").gotoTerminal(4)
				end,
				desc = "Terminal 4",
			},
		},
	},
}
