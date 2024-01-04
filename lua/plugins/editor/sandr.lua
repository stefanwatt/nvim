return {
	{
		"stefanwatt/sandr",
		opts = {
			jump_forward = "<Tab>",
			jump_backward = "<S-Tab>",
			completion = "<C-Space>",
			flags = "gc",
			range = "%",
		},
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
