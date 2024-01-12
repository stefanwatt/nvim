return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		plugins = { spelling = true },
		defaults = {
			mode = { "n" },
		},
	},
	config = function()
		local wk = require("which-key")
		wk.register({
			a = { name = "Quickfix" },
			c = { name = "Conform" },
			f = { name = "Find" },
			g = { name = "Git" },
			h = { name = "Harpoon" },
			l = { name = "LSP" },
			["<leader><leader>"] = { name = "Misc" },
		}, { prefix = "<leader>" })
	end,
}
