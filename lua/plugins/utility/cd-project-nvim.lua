return {
	{
		dir = "~/Projects/cd-project.nvim/",
		dev = true,
		lazy = false,
		keys = {
			{
				"<C-p>",
				mode = { "n" },
				function()
					START_TIME = os.clock()
					print(string.format("%s - %.3f ms", "Start", (os.clock() - START_TIME) * 1000))
					vim.cmd("CdProject")
				end,
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
				default_project_dirs = { "~/Projects", "~/.config" },
				hooks = {
					{
						callback = function(dir)
							if not require("persistence").load() then
								vim.cmd("silent! e " .. dir)
							end
						end,
						order = 1,
						trigger_point = "AFTER_CD",
					},
				},
			})
		end,
	},
}
