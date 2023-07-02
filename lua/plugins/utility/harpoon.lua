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
				"<Tab>",
				mode = { "n" },
				function()
					require("harpoon.ui").nav_prev()
				end,
				desc = "Harpoon next file",
			},
		},
	},
}
