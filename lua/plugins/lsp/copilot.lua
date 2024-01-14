return {

	"zbirenbaum/copilot-cmp",
	dependencies = {
		"zbirenbaum/copilot.lua",
	},
	event = "BufReadPre",
	build = ":Copilot auth",
	opts = {
		suggestion = { enabled = false },
		panel = { enabled = false },
		filetypes = {
			markdown = true,
			help = true,
		},
	},
	config = function()
		require("copilot").setup({
			suggestion = { enabled = false },
			panel = { enabled = false },
		})
		local copilot_cmp = require("copilot_cmp")
		copilot_cmp.setup()
	end,
}
