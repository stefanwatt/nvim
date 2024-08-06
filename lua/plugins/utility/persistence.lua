return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	opts = {
		dir = vim.fn.stdpath("state") .. "/sessions/", 
		need = 1,
		branch = true, -- use git branch to save session
	}
}
