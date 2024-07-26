return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{
			"<leader>fw",
			mode = { "n" },
			"<cmd>FzfLua live_grep<cr>",
			desc = "[f]ind [w]ord",
		},
		{
			"<leader>ff",
			mode = { "n" },
			"<cmd>FzfLua git_files<cr>",
			desc = "[f]ind [f]iles",
		},
		{
			"<leader>fw",
			mode = { "n" },
			"<cmd>FzfLua live_grep<cr>",
			desc = "[f]ind [w]ord",
		},
	},
	config = function()
		require("fzf-lua").setup({
			keymap = {
				fzf = {
					["ctrl-q"] = "select-all+accept",
				},
			},
		})
	end,
}
