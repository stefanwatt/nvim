return {
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		dependencies = { "nvim-telescope/telescope.nvim" },
		keys = {
			{
				"<leader>gd",
				mode = { "n" },
				function()
					local actions = require("telescope.actions")
					local action_state = require("telescope.actions.state")
					local builtin = require("telescope.builtin")

					local function custom_git_commit_action(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						local current_file = vim.fn.expand("%")
						vim.api.nvim_command("G diff " .. selection.value .. " -- %")
						vim.schedule(function()
							vim.api.nvim_command("only")
							vim.api.nvim_buf_set_keymap(0, "n", "q", ":bdelete<cr>", {silent=true})
						end)
					end
					builtin.git_commits({
						attach_mappings = function(_, map)
							actions.select_default:replace(custom_git_commit_action)
							return true
						end,
					})
				end,
				desc = "[git] diff",
			},
		},
	},
	{
		"f-person/git-blame.nvim",
		config = function()
			require("gitblame").setup({
				enabled = false,
			})
		end,
		event = "VeryLazy",
		keys = {
			{
				"<leader>gb",
				mode = { "n" },
				":GitBlameToggle<CR>",
				desc = "Git Blame",
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					map("n", "]c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end)

					map("n", "[c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end)

					-- Actions
					map("n", "<leader>ghs", gitsigns.stage_hunk)
					map("n", "<leader>ghr", gitsigns.reset_hunk)
					map("v", "<leader>ghs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("v", "<leader>ghr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("n", "<leader>ghS", gitsigns.stage_buffer)
					map("n", "<leader>ghu", gitsigns.undo_stage_hunk)
					map("n", "<leader>ghR", gitsigns.reset_buffer)
					map("n", "<leader>ghp", gitsigns.preview_hunk)
					map("n", "<leader>ghb", function()
						gitsigns.blame_line({ full = true })
					end)
					map("n", "<leader>ghd", gitsigns.diffthis)
					map("n", "<leader>ghD", function()
						gitsigns.diffthis("~")
					end)
				end,
			})
		end,
	},
}
