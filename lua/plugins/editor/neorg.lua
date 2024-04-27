return {
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
	},
	{
		"nvim-neorg/neorg",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"3rd/image.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-neotest/nvim-nio",
			"nvim-neorg/lua-utils.nvim",
		},
		build = ":Neorg sync-parsers",
		version = "*",
		ft = "norg", -- lazy load on file type
		cmd = "Neorg", -- lazy load on command
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {}, -- Loads default behaviour
					["core.export"] = {}, -- Loads default behaviour
					["core.concealer"] = {}, -- Adds pretty icons to your documents
					["core.dirman"] = { -- Manages Neorg workspaces
						config = {
							workspaces = {
								notes = "~/notes",
							},
						},
					},
					["core.keybinds"] = {
						config = {
							default_keybinds = true,
							hook = function(keybinds)
								keybinds.map("norg", "n", "T", "<cmd>Neorg toc right<CR>")
							end,
						},
					},
				},
			})
		end,
	},
}
