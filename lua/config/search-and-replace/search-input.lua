local utils = require("config.search-and-replace.utils")
local SearchInput = {}
SearchInput.__index = SearchInput

---@type boolean
local mounted = false
---@type number
local original_buf_id = nil
---@type number
local original_window_id = nil
---@type string
local search_term = ""
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
			top = "Search",
			top_align = "center",
		},
	},
	position = {
		row = 0,
		col = "100%",
	},
	size = {
		width = 15,
		height = 1,
	},
}
-- Constructor
function SearchInput.new(original_buf_id, original_window_id)
	local self = setmetatable({}, SearchInput)
	if original_buf_id ~= nil then
		self.original_buf_id = original_buf_id
	end
	if original_window_id ~= nil then
		self.original_window_id = original_window_id
	end
	input = require("nui.input")(default_popup_options, {
		on_change = function(value)
			self.search_term = value
			utils.highlightMatches(value, self.original_buf_id)
		end,
	})

	input:map("i", "<CR>", function()
		utils.jumpToNextMatch(self.search_term, self.original_buf_id, self.original_window_id)
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

function SearchInput:set_original_buf_id(original_buf_id)
	self.original_buf_id = original_buf_id
end

function SearchInput:set_original_window_id(original_window_id)
	self.original_window_id = original_window_id
end

function SearchInput:show()
	if mounted then
		input:show()
		local col = self.search_term ~= nil and #self.search_term + 1 or 1
		vim.api.nvim_set_current_win(input_window_id)
		return
	end
	input:mount()
	mounted = true
end

function SearchInput:hide()
	if not mounted then
		input:hide()
		return
	end
	input:unmount()
	mounted = false
end

return SearchInput
