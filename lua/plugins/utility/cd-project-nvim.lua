return {
	{
		dir = "~/Projects/cd-project.nvim/",
		dev = true,
		keys = {
			{
				"<leader>pc",
				mode = { "n" },
				"<CMD>CdProject<CR>",
				desc = "change project",
			},
			{
				"<leader>pa",
				mode = { "n" },
				"<CMD>CdProjectAdd<CR>",
				desc = "add project",
			},
			{
				"<leader>pb",
				mode = { "n" },
				"<CMD>CdProjectBack<CR>",
				desc = "go to last project",
			},
		},
		config = function()
			require("cd-project").setup({
				projects_config_filepath = vim.fs.normalize(vim.fn.stdpath("config") .. "/cd-project.nvim.json"),
				project_dir_pattern = { ".git", ".gitignore", "Cargo.toml", "package.json", "go.mod" },
			})
		end,
	},
}
