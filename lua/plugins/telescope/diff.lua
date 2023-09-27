return {
	{
		"jemag/telescope-diff.nvim",
		dependencies = {
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("telescope").load_extension("diff")
		end,
	},
}
