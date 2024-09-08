return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		-- enabled = false,
		opts = {
			modes = {
				search = {
					enabled = false,
				},
			},
		},
		keys = {
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump({
						search = {
							mode = function(str)
								return "\\<" .. str
							end,
						},
					})
				end,
				desc = "Flash",
			},
		},
	},
}
