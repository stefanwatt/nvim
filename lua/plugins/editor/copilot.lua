return {
	{
		"zbirenbaum/copilot.lua",
		event = "VeryLazy",
		cmd = "Copilot",
		keys = {
			{
				"<A-space>",
				mode = { "i", "n" },
				function()
					vim.schedule(function()
						require("copilot.suggestion").next()
					end)
				end,
				desc = "copilot suggestion",
			},
		},
		build = ":Copilot auth",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = false,
				debounce = 0,
				keymap = {
					accept = "<C-y>",
					accept_word = false,
					accept_line = false,
					next = "<C-space>",
					prev = false,
					dismiss = "<Esc>",
				},
			},
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},
}
