local colors = require("catppuccin.palettes").get_palette("frappe")
local visible = true
function get_tmux_session_name()
	if not os.getenv("TMUX") then
		return ""
	end
	local f = io.popen("tmux display-message -p '#S'")
	if not f then
		return ""
	end
	local session_name = f:read("*a") or ""
	f:close()
	session_name = string.gsub(session_name, "\n$", "")
	return session_name
end

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
						{ get_tmux_session_name, color = { fg = colors.flamingo, gui = "bold" } },
						{ "filename" },
					},
				},
			})
			vim.o.cmdheight = 0
			vim.o.laststatus = 3
		end,
	},
}
