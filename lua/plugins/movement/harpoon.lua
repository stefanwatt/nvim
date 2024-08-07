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
				"<leader>1",
				mode = { "n" },
				function()
					require("harpoon.ui").nav_file(1)
				end,
				desc = "Nav File 1",
			},
			{
				"<leader>2",
				mode = { "n" },
				function()
					require("harpoon.ui").nav_file(2)
				end,
				desc = "Nav File 2",
			},
			{
				"<leader>3",
				mode = { "n" },
				function()
					require("harpoon.ui").nav_file(3)
				end,
				desc = "Nav File 3",
			},
			{
				"<leader>4",
				mode = { "n" },
				function()
					require("harpoon.ui").nav_file(4)
				end,
				desc = "Nav File 3",
			},
			{
				"<leader>5",
				mode = { "n" },
				function()
					require("harpoon.ui").nav_file(5)
				end,
				desc = "Nav File 5",
			},
			{
				"<leader>6",
				mode = { "n" },
				function()
					require("harpoon.ui").nav_file(6)
				end,
				desc = "Nav File 6",
			},
			{
				"<leader>7",
				mode = { "n" },
				function()
					require("harpoon.ui").nav_file(7)
				end,
				desc = "Nav File 7",
			},
			{
				"<leader>8",
				mode = { "n" },
				function()
					require("harpoon.ui").nav_file(8)
				end,
				desc = "Nav File 8",
			},
			{
				"<leader>9",
				mode = { "n" },
				function()
					require("harpoon.ui").nav_file(9)
				end,
				desc = "Nav File 9",
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
