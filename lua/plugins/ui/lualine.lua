local visible = true

return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			"AndreM222/copilot-lualine",
		},
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
					lualine_x = {
						{
							"copilot",
							symbols = {
								status = {
									icons = {
										enabled = " ",
										sleep = " ",
										disabled = " ",
										warning = " ",
										unknown = " ",
									},
									hl = {
										enabled = "#a6d189",
										sleep = "#a5adce",
										disabled = "#f2d5cf",
										warning = "#ef9f76",
										unknown = "#e78284",
									},
								},
								spinners = require("copilot-lualine.spinners").dots,
								spinner_color = "#6272A4",
							},
							show_colors = false,
							show_loading = true,
						},
						"encoding",
						"fileformat",
						"filetype",
					},
				},
			})
			vim.o.cmdheight = 0
			vim.o.laststatus = 3
		end,
	},
}
