return {
	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup({
				app = "/run/current-system/sw/bin/brave",
			})
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},
	{
		"OXY2DEV/markview.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local markview = require("markview")
			markview.setup({
				headings = {
					enable = false,
				},
			})
			vim.cmd("Markview enableAll")
		end,
	},
	{
		"lukas-reineke/headlines.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = true
	},
}
