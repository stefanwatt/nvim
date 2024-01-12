return {
	"stefanwatt/mini.files",
	commit = "adf56c3c673c483d9c1d08f1b26db99defcf0204",
	lazy = false,
	config = function()
		require("mini.files").setup({
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
				-- Whether to use for editing directories
				use_as_default_explorer = true,
				fs_actions_confirm = false,
				close_on_file_opened = true,
				open_on_current_dir = true,
			},
		})
	end,
	keys = {
		{
			"<leader>e",
			mode = { "n" },
			function()
				MiniFiles.open()
			end,
			desc = "File Explorer",
		},
	},
}
