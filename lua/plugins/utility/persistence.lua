return {
	"folke/persistence.nvim",
	lazy = false,
	config = function()
		require("persistence").setup({
			dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- directory where session files are saved
			options = { "buffers", "curdir", "tabpages", "winsize", "skiprtp" }, -- sessionoptions used for saving
			save_empty = false, -- don't save if there are no open file buffers
		})
		require("persistence").load({ last = true })
	end,
}
