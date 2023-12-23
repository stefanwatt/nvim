local utils = require("config.search-and-replace.utils")
local ReplaceInput = {}
ReplaceInput.__index = ReplaceInput

---@type boolean
local mounted = false
---@type number
local original_buf_id = nil
---@type number
local original_window_id = nil
---@type string
local replace_term = ""
---@type number
local input_buf_id = nil
---@type number
local input_window_id = nil

---@type NuiInput
local input = nil

---@type nui_popup_options
local default_popup_options = {
	enter = true,
	focusable = true,
	border = {
		style = "rounded",
		text = {
			top = "Replace",
			top_align = "center",
		},
	},
	position = {
		row = 4,
		col = "100%",
	},
	size = {
		width = 15,
		height = 1,
	},
}
-- Constructor
function ReplaceInput.new(original_buf_id, original_window_id)
	local self = setmetatable({}, ReplaceInput)
	if original_buf_id ~= nil then
		self.original_buf_id = original_buf_id
	end
	if original_window_id ~= nil then
		self.original_window_id = original_window_id
	end
	input = require("nui.input")(default_popup_options, {
		on_change = function(value)
			self.replace_term = value
		end,
	})

	input:map("i", "<CR>", function()
		utils.replace_current_match()
	end, { noremap = true })

	input:map("i", "<Esc>", function()
		input:hide()
	end, { noremap = true })

	input:on("BufLeave", function()
		input_buf_id = vim.api.nvim_get_current_buf()
		input_window_id = vim.api.nvim_get_current_win()
	end, {})
	return self
end

function ReplaceInput:set_original_buf_id(original_buf_id)
	self.original_buf_id = original_buf_id
end

function ReplaceInput:set_original_window_id(original_window_id)
	self.original_window_id = original_window_id
end

function ReplaceInput:show()
	if mounted then
		input:show()
		local col = self.search_term ~= nil and #self.search_term + 1 or 1
		vim.api.nvim_set_current_win(input.winid)
		if self.search_term ~= nil then
			vim.api.nvim_win_set_cursor(input.winid, { 1, #self.search_term })
		end
		vim.api.nvim_command("startinsert!")
		return
	end
	input:mount()
	mounted = true
end

function ReplaceInput:hide()
	if not mounted then
		input:hide()
		return
	end
	input:unmount()
	mounted = false
end

function ReplaceInput:get_opts()
	return default_popup_options
end

return ReplaceInput
