return {
	-- {
	-- 	"mini.files",
	-- 	name = "mini.files",
	-- 	dir = "/home/stefan/Projects/mini.files",
	--
	-- 	dependencies = {
	-- 		"nvim-tree/nvim-web-devicons",
	-- 	},
	-- 	lazy = false,
	-- 	opts = {
	-- 		use_as_default_explorer = true,
	-- 	},
	-- 	keys = {
	-- 		{
	-- 			"<leader>e",
	-- 			mode = { "n" },
	-- 			"<cmd>lua require('mini.files').open(vim.api.nvim_buf_get_name(0), false)<cr>",
	-- 			desc = "File Explorer",
	-- 		},
	-- 	},
	-- },
	{
		"stefanwatt/mini.files",
		commit ="4a5298e0035eb32bc9ba6e49957dc3f397ecbb46",
		version = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			{ "antosha417/nvim-lsp-file-operations", dependencies = { "nvim-lua/plenary.nvim" } },
		},
		lazy = false,
		opts = {
			use_as_default_explorer = true,
		},
		keys = {
			{
				"<leader>E",
				mode = { "n" },
				"<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<cr>",
				desc = "File Explorer",
			},
		},
		config = function()
			require("mini.files").setup({
				windows ={
					preview = true
				},
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
