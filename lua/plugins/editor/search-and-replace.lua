return {
	{
		-- "chrisgrieser/nvim-rip-substitute",
		"rip-substitute",
		dependencies = { "CWood-sdf/banana.nvim" },
		name = "nvim-rip-substitute",
		dir = "/home/stefan/Projects/nvim-rip-substitute",
		keys = {
			{
				"<C-h>",
				function()
					require("rip-substitute").sub()
				end,
				mode = { "n", "x" },
				desc = " rip sub",
			},
		},
		event = "VeryLazy",
		config = function()
			require("rip-substitute").setup({
				popupWin = {
					position = "top",
				},
				prefill = {
					normal = false, -- "cursorWord"|false
					visual = "selectionFirstLine", -- "selectionFirstLine"|false
					startInReplaceLineIfPrefill = true,
				},
				keymaps = {
					confirm = "<S-CR>",
					confirmSingle = "<CR>",
					prevSubst = "<A-Up>",
					nextSubst = "<A-Down>",
					prevMatch = "<Up>",
					nextMatch = "<Down>",
				},
			})
		end,
	},
	{
		"MagicDuck/grug-far.nvim",
		enabled = false,
		keys = {
			{
				"<leader>r",
				mode = { "n" },
				function()
					require("grug-far").grug_far()
				end,
				desc = "search and replace",
			},
			{
				"<leader>r",
				mode = { "v", "x" },
				function()
					require("grug-far").with_visual_selection()
				end,
				desc = "search and replace",
			},
		},
		config = function()
			require("grug-far").setup()
		end,
	},
}
