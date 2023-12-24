local utils = require("config.search-and-replace.utils")
---@class ReplaceInput
---@field mounted boolean
---@field original_buf_id? number
---@field original_window_id? number
---@field replace_term? string
---@field nui_input? NuiInput
---@field popup_options? nui_popup_options
local ReplaceInput = {}
ReplaceInput.__index = ReplaceInput

---@type ReplaceInput
local default_props = {
	mounted = false,
	original_buf_id = nil,
	original_window_id = nil,
	replace_term = "",
	nui_input = nil,
	popup_options = {
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
	},
}

---@param original_buf_id number
---@param original_window_id number
---@return ReplaceInput
function ReplaceInput.new(original_buf_id, original_window_id)
	local props = default_props
	local self = setmetatable(props, ReplaceInput)
	local outer_self = self
	self.original_buf_id = original_buf_id
	self.original_window_id = original_window_id

	self.nui_input = require("nui.input")(props.popup_options, {
		on_change = function(value)
			outer_self.replace_term = value
		end,
	})

	return self
end

---@param original_buf_id number
function ReplaceInput:set_original_buf_id(original_buf_id)
	self.original_buf_id = original_buf_id
end

---@param original_window_id number
function ReplaceInput:set_original_window_id(original_window_id)
	self.original_window_id = original_window_id
end

function ReplaceInput:show()
	if self.mounted then
		self.nui_input:show()
		self:focus()
		return
	end
	self.nui_input:mount()
	self.mounted = true
end

function ReplaceInput:hide()
	if not self.mounted then
		self.nui_input:hide()
		return
	end
	self.nui_input:unmount()
	self.mounted = false
end

function ReplaceInput:get_popup_opts()
	return self.popup_options
end

function ReplaceInput:focus()
	local col = self.replace_term ~= nil and #self.replace_term + 1 or 1
	vim.api.nvim_set_current_win(self.nui_input.winid)
	if self.replace_term ~= nil then
		vim.api.nvim_win_set_cursor(self.nui_input.winid, { 1, #self.replace_term })
	end
	vim.api.nvim_command("startinsert!")
end

return ReplaceInput
