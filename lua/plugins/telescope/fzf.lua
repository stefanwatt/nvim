return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{
			"<leader>ff",
			mode = { "n" },
			"<cmd>FzfLua git_files<cr>",
			desc = "[f]ind [f]iles",
		},
	},
	config = function()
		require("fzf-lua").setup({})
	end,
}
