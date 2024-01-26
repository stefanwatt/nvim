return {
	{
		"jemag/telescope-diff.nvim",
		enabled = false,
		dependencies = {
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("telescope").load_extension("diff")
		end,
	},
}
