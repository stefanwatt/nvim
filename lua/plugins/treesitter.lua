return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"css",
					"diff",
					"git_config",
					"git_rebase",
					"gitattributes",
					"gitcommit",
					"gitignore",
					"html",
					"javascript",
					"jsdoc",
					"json",
					"json5",
					"lua",
					"markdown",
					"markdown_inline",
					"nix",
					"regex",
					"ssh_config",
					"svelte",
					"toml",
					"typescript",
					"vim",
					"vimdoc",
					"query",
					"xml",
					"yaml",
				},
				sync_install = false,
				auto_install = true,
				modules = {},
				ignore_install = {},
				highlight = {
					enable = true,
					disable = function(_, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
	{
		"Wansmer/treesj",
		event = "VeryLazy",
		keys = { "<space>m", "<space>j", "<space>s" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({ max_join_length = 999 })
		end,
	},
	{
		"AndrewRadev/tagalong.vim",
		event = "VeryLazy",
		config = function()
			vim.g.tagalong_filetypes = { "svelte" }
		end,
	},
}
