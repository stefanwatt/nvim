return {
	{
		dir = "~/Projects/sandr/",
		dev = true,
		keys = {
			{
				"<C-h>",
				mode = { "n" },
				function()
					require("sandr").search_and_replace({})
				end,
				desc = "Search and replace",
			},
			{
				"<C-h>",
				mode = { "v" },
				function()
					require("sandr").search_and_replace({ visual = true })
				end,
				desc = "Search and replace",
			},
		},
	},
}
