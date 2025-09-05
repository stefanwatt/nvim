return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
	{
		"bngarren/checkmate.nvim",
		ft = "markdown",
		opts = {
			files = { "*.md" },
		},
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
}

-- {
-- 	"OXY2DEV/markview.nvim",
-- 	enabled = false,
-- 	event = "VeryLazy",
-- 	dependencies = {
-- 		"nvim-treesitter/nvim-treesitter",
-- 		"nvim-tree/nvim-web-devicons",
-- 	},
-- 	config = function()
-- 		local markview = require("markview")
-- 		markview.setup({
-- 			headings = {
-- 				enable = false,
-- 			},
-- 		})
-- 		vim.cmd("Markview enableAll")
-- 	end,
-- },
-- {
-- 	"lukas-reineke/headlines.nvim",
-- 	enabled = false,
-- 	dependencies = "nvim-treesitter/nvim-treesitter",
-- 	config = true,
-- },
