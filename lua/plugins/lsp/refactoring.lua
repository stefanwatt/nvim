return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("refactoring").setup()
	end,
	keys = {
		{
			"<C-A-v>",
			mode = "x",
			function()
				require("refactoring").refactor("Extract Variable")
			end,
			desc = "Extract Variable",
		},
		{
			"<C-A-f>",
			mode = "x",
			function()
				require("refactoring").refactor("Extract Function")
			end,
			desc = "Extract Function",
		},
	},
}
