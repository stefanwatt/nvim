local utils = require("config.search-and-replace.utils")
---@class ReplaceInput
---@field mounted boolean
---@field original_buf_id? number
---@field original_window_id? number
---@field value? string
---@field nui_input? NuiInput
---@field popup_options? nui_popup_options
local ReplaceInput = {}
ReplaceInput.__index = ReplaceInput

---@type ReplaceInput

---@param original_buf_id number
---@param original_window_id number
---@return ReplaceInput
function ReplaceInput.new(original_buf_id, original_window_id)
	local outer_self = self
	local props = require("config.search-and-replace.constants").get_replace_input_props({
		original_buf_id = original_buf_id,
		original_window_id = original_window_id,
	})
	props.nui_input = require("nui.input")(props.popup_options, {
		on_change = function(value)
			outer_self.value = value
		end,
	})
	local self = setmetatable(props, ReplaceInput)
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
	if not self.mounted then
		print("mounting new replace input")
		self.nui_input:mount()
		self.mounted = true
	end
	self.nui_input:show()
	self:focus()
end

function ReplaceInput:hide()
	if not self.mounted then
		return
	end
	self.nui_input:hide()
end

function ReplaceInput:get_popup_opts()
	return self.popup_options
end

function ReplaceInput:focus()
	local col = self.value ~= nil and #self.value + 1 or 1
	vim.api.nvim_set_current_win(self.nui_input.winid)
	if self.value ~= nil then
		vim.api.nvim_win_set_cursor(self.nui_input.winid, { 1, #self.value })
	end
	vim.api.nvim_command("startinsert!")
end

return ReplaceInput
