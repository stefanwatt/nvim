return {
	{
		"echasnovski/mini.files",
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
				"<leader>e",
				mode = { "n" },
				"<cmd>lua MiniFiles.open()<cr>",
				desc = "File Explorer",
			},
		},
		config = function()
			require("plugins.files.my-files").setup({

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
			require("lsp-file-operations").setup()

			local events = {
				["lsp-file-operations.did-rename"] = { { "MiniFilesActionRename", "MiniFilesActionMove" }, "Renamed" },
				["lsp-file-operations.will-create"] = { "MiniFilesActionCreate", "Create" },
				["lsp-file-operations.will-delete"] = { "MiniFilesActionDelete", "Delete" },
			}
			local au_group = vim.api.nvim_create_augroup("mini_files", { clear = true })
			for module, pattern in pairs(events) do
				vim.api.nvim_create_autocmd("User", {
					pattern = pattern[1],
					group = au_group,
					desc = string.format("Auto-refactor LSP file %s", pattern[2]),
					callback = function(event)
						local ok, action = pcall(require, module)
						if not ok then
							return
						end
						local args = {}
						local data = event.data
						if data.from == nil or data.to == nil then -- when the `pattern` is "create" or "delete"
							args = { fname = data.from or data.to }
						else
							args = { old_name = data.from, new_name = data.to }
						end
						action.callback(args)
					end,
				})
			end
		end,
	},
}
