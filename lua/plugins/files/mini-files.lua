return {
	{
		"stefanwatt/mini.files",
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
				"<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<cr>",
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
				windows = {
					max_number = math.huge,
					preview = true,
					width_focus = 50,
					width_nofocus = 15,
					width_preview = 100,
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
