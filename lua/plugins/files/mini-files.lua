return {
	{
		"mini.files",
		name = "mini.files",
		dir = "/home/stefan/Projects/mini.files",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		lazy = false,
		opts = {
			use_as_default_explorer = true,
		},
		keys = {
			{
				"<leader>e",
				mode = { "n" },
				"<cmd>lua require('mini.files').open(vim.api.nvim_buf_get_name(0), false)<cr>",
				desc = "File Explorer",
			},
		},
		config = function()
			require("mini.files").setup({
				content = {
					filter = nil,
					sort = nil,
				},
				mappings = {
					close = "q",
					go_in_plus = "<Right>",
					go_in = "L",
					go_out_plus = "<Left>",
					go_out = "H",
					reset = "<BS>",
					show_help = "?",
					synchronize = "=",
					trim_left = "<",
					trim_right = ">",
				},
				options = {
					use_as_default_explorer = true,
					confirm_fs_actions = false,
					close_on_file_opened = true,
					open_on_current_dir = true,
				},
			})
		end,
	},
}
