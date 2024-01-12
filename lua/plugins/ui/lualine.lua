local visible = 0
vim.g.lualine_laststatus = 0
vim.o.laststatus = 0
return {
	{
		"nvim-lualine/lualine.nvim",
		keys = {
			{
				"<leader><leader>s",
				mode = { "n" },
				function()
					if visible ~= 0 then
						vim.o.laststatus = 0
						visible = 0
					else
						vim.o.laststatus = 3
						visible = 3
					end
				end,
				desc = "Toggle Lualine",
			},
		},
		event = function(_, events)
			events = {}
			return {}
		end,
	},
}
