return {
	"dpayne/CodeGPT.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.g["codegpt_commands_defaults"] = {
			["model"] = "gpt-4o",
		}
		vim.g["codegpt_popup_type"] = "horizontal"
		require("codegpt.config")
	end,
}
