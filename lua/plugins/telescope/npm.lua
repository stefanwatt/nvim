return {
	{
		"elianiva/telescope-npm.nvim",
		enabled = false,
		config = function()
			require("tasks.sources.npm")
		end,
	},
}
