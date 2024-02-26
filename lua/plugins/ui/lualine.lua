local colors = require("catppuccin.palettes").get_palette("frappe")
local visible = true

return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader><leader>s",
				mode = { "n" },
				function()
					if not visible then
						vim.o.laststatus = 3
						visible = true
					else
						vim.o.laststatus = 0
						visible = false
					end
				end,
				desc = "Toggle Lualine",
			},
		},
		config = function()
			require("lualine").setup({
				sections = {
					lualine_c = {
						{ "filename" },
					},
				},
			})
			vim.o.cmdheight = 0
			vim.o.laststatus = 3
		end,
	},
}
