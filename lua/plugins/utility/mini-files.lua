return {
	{
		"echasnovski/mini.files",
		version = false,
		event = "VeryLazy",
		keys = {
			{
				"<leader>e",
				mode = { "n" },
				"<cmd>lua MiniFiles.open()<cr>",
				desc = "File Explorer",
			},
		},
		config = function()
			require("plugins.utility.my-files").setup({

				-- require("mini.files").setup({
				-- Customization of shown content
				content = {
					-- Predicate for which file system entries to show
					filter = nil,
					-- In which order to show file system entries
					sort = nil,
				},

				-- Module mappings created only inside explorer.
				-- Use `''` (empty string) to not create one.
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

				-- General options
				options = {
					-- Whether to use for editing directories
					use_as_default_explorer = true,
					fs_actions_confirm = false,
					close_on_file_opened = true,
					open_on_current_dir = true,
				},

				-- Customization of explorer windows
				windows = {
					-- Maximum number of windows to show side by side
					max_number = math.huge,
					-- Whether to show preview of directory under cursor
					preview = true,
					-- Width of focused window
					width_focus = 50,
					-- Width of non-focused window
					width_nofocus = 15,
				},
			})
		end,
	},
}
