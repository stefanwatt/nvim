local function remove_other_buffers()
	local bufremove = require("mini.bufremove")
	local open_bufs = vim.api.nvim_list_bufs()
	local current_buf = vim.api.nvim_get_current_buf()
	for i, buf in pairs(open_bufs) do
		if buf ~= current_buf then
			bufremove.delete(buf)
		end
	end
end

return {
	"echasnovski/mini.bufremove",
	version = "*",
	keys = {
		{
			"<leader>c",
			"<cmd>lua MiniBufremove.delete()<CR>",
			desc = "Close Buffer",
		},
		{
			"<leader>C",
			mode = { "n" },
			remove_other_buffers,
			desc = "Close all Buffers",
		},
	},
	event = "VeryLazy",
	config = true,
}
