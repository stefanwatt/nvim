local utils = require("config.search-and-replace.utils")
local SearchInput = {}
SearchInput.__index = SearchInput

local default_props = {
	---@type boolean
	mounted = false,
	---@type number
	original_buf_id = nil,
	---@type number
	original_window_id = nil,
	---@type string
	search_term = "",
	---@type table {row: number, col: number}
	current_match = nil,
	---@type nui_popup_options
	---@type NuiInput
	nui_input = nil,
	popup_options = {
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
	},
}

-- Constructor
---comment
---@param original_buf_id number
---@param original_window_id number
function SearchInput.new(original_buf_id, original_window_id)
	local props = default_props
	local self = setmetatable(props, SearchInput)
	local outer_self = self
	self.original_buf_id = original_buf_id
	self.original_window_id = original_window_id

	self.nui_input = require("nui.input")(props.popup_options, {
		on_change = function(value)
			outer_self.search_term = value
			utils.highlightMatches(value, outer_self.original_buf_id)
		end,
	})

	self.nui_input:map("i", "<CR>", function()
		outer_self.current_match =
			utils.jumpToNextMatch(outer_self.search_term, outer_self.original_buf_id, outer_self.original_window_id)
	end, { noremap = true })

	-- self.nui_input:map("i", "<Esc>", function()
	--   self.nui_input:hide()
	-- end, { noremap = true })
	return self
end

function SearchInput:set_original_buf_id(original_buf_id)
	self.original_buf_id = original_buf_id
end

function SearchInput:set_original_window_id(original_window_id)
	self.original_window_id = original_window_id
end

function SearchInput:show()
	if self.mounted then
		self.nui_input:show()
		local col = self.search_term ~= nil and #self.search_term + 1 or 1
		vim.api.nvim_set_current_win(self.nui_input.winid)
		if self.search_term ~= nil then
			vim.api.nvim_win_set_cursor(self.nui_input.winid, { 1, #self.search_term })
		end
		vim.api.nvim_command("startinsert!")
		return
	end
	self.nui_input:mount()
	self.mounted = true
end

function SearchInput:hide()
	if not self.mounted then
		self.nui_input:hide()
		return
	end
	self.nui_input:unmount()
	self.mounted = false
end

function SearchInput:get_popup_opts()
	return self.props.popup_options
end

return SearchInput
