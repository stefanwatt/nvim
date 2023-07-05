return {
	{
		"nvim-pack/nvim-spectre",
		keys = {
			{
				"<leader>r",
				mode = { "n" },
				function()
					require("spectre").open_file_search()
				end,
				desc = "Spectre file",
			},
			{
				"<leader>R",
				mode = { "n" },
				function()
					require("spectre").open()
				end,
				desc = "Spectre global",
			},
			{
				"<leader>r",
				mode = { "v", "x" },
				"<ESC><cmd>lua require('spectre').open_file_search()<cr>",
				desc = "Search and replace (file)",
			},
			{
				"<leader>R",
				mode = { "v", "x" },
				"<cmd>lua require('spectre').open_visual()<cr>",
				desc = "Search and replace (global)",
			},
		},
	},
}
