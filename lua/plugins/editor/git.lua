return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{
				"<leader>ngg",
				mode = { "n" },
				":Neogit<CR>",
				desc = "Neogit",
			},
			{
				"<leader>ngc",
				mode = { "n" },
				":Neogit commit<CR>",
				desc = "Neogit Commit",
			},
		},
		config = true,
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
					map("n", "<leader>gtb", gitsigns.toggle_current_line_blame)
					map("n", "<leader>ghd", gitsigns.diffthis)
					map("n", "<leader>ghD", function()
						gitsigns.diffthis("~")
					end)
					map("n", "<leader>gtd", gitsigns.toggle_deleted)

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			})
		end,
	},
}
