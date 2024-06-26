return {
	"echasnovski/mini.bufremove",
	version = "*",
	keys = {
		{
			"<leader>c",
			mode = { "n" },
			"<cmd>lua MiniBufremove.delete()<CR>",
			desc = "Close Buffer",
		},
		{
			"<leader>C",
			mode = { "n" },
			"<cmd>MiniBufremoveAllExceptCurrent<CR>",
			desc = "Close all Buffers",
		},
	},
	event = "VeryLazy",
	config = function()
		local bufremove = require("mini.bufremove")
		bufremove.setup()
		local function removeAllExceptCurrent()
			local open_bufs = vim.api.nvim_list_bufs()
			local current_buf = vim.api.nvim_get_current_buf()
			for i, buf in pairs(open_bufs) do
				if buf ~= current_buf then
					bufremove.delete(buf)
				end
			end
		end
		vim.api.nvim_create_user_command("MiniBufremoveAllExceptCurrent", removeAllExceptCurrent, {})
	end,
}
