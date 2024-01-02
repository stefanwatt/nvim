return {
	{
		"tris203/hawtkeys.nvim",
		config = {
			customMaps = {
				--- EG local map = vim.api
				--- map.nvim_set_keymap('n', '<leader>1', '<cmd>echo 1')
				{
					["keymap"] = { --name of the expression
						modeIndex = "1", -- the position of the mode setting
						lhsIndex = "2", -- the position of the lhs setting
						rhsIndex = "3", -- the position of the rhs setting
						optsIndex = "4", -- the position of the index table
					},
				},
			},
		},
	},
}
