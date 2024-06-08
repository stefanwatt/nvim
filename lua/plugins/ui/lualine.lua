local visible = true

local function macro_recording_status()
	local recording_register = vim.fn.reg_recording()
	if recording_register ~= "" then
		return "Recording @" .. recording_register
	end
	return ""
end

local custom_fname = require('lualine.components.filename'):extend()

function custom_fname:init(options)
	custom_fname.super.init(self, options)
end

function custom_fname:update_status()
	local data = vim.fn.expand('%:t')
	if data == "" then
		data = "[No Name]"
	end

	if not vim.bo.modified then return data end
	return "%#DiagnosticSignWarn#" .. data .. ' ●'
end

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
						custom_fname,
						macro_recording_status
					},
					lualine_x = { 'filetype' },
					lualine_y = {
						{
							'fileformat',
							icons_enabled = true,
							symbols = {
								unix = 'LF',
								dos = 'CRLF',
								mac = 'CR',
							},
						},
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
