local SearchInput = require("config.search-and-replace.search-input")
local ReplaceInput = require("config.search-and-replace.replace-input")
local utils = require("config.search-and-replace.utils")
---@class SearchAndReplaceDialog
---@field visible boolean
---@field search_input? SearchInput
---@field replace_input? ReplaceInput
---@field layout_options? nui_layout_options
local SearchAndReplaceDialog = {}
SearchAndReplaceDialog.__index = SearchAndReplaceDialog

local default_props = {
	visible = false,
	search_input = nil,
	replace_input = nil,
	focused_input = nil,
	layout_options = nil,
}

---@param original_buf_id number
---@param original_window_id number
function SearchAndReplaceDialog.new(original_buf_id, original_window_id)
	local props = default_props
	local self = setmetatable(props, SearchAndReplaceDialog)
	local outer_self = self
	self.search_input = SearchInput.new(original_buf_id, original_window_id)
	self.replace_input = ReplaceInput.new(original_buf_id, original_window_id)
	self.replace_input.nui_input:map("i", "<CR>", function()
		outer_self:replace_current_match()
	end, { noremap = true })

	self.replace_input.nui_input:map("i", "<TAB>", function()
		outer_self:focus_input(outer_self.search_input)
	end, { noremap = true })
	self.replace_input.nui_input:map("n", "<TAB>", function()
		outer_self:focus_input(outer_self.search_input)
	end, { noremap = true })

	self.search_input.nui_input:map("i", "<TAB>", function()
		outer_self:focus_input(outer_self.replace_input)
	end, { noremap = true })
	self.search_input.nui_input:map("n", "<TAB>", function()
		outer_self:focus_input(outer_self.replace_input)
	end, { noremap = true })

	local outer_self = self
	return self
end

---@param input SearchInput | ReplaceInput
function SearchAndReplaceDialog:focus_input(input)
	input:focus()
	self.focused_input = input
end

function SearchAndReplaceDialog:replace_current_match()
	local current_match = self.search_input.current_match
	local replace_term = self.replace_input.replace_term
	if replace_term and current_match then
		utils.replace_current_match(replace_term, current_match, self.replace_input.original_buf_id)
		local updated_matches = utils.get_matches(self.search_input.search_term, self.search_input.original_buf_id)
		local updated_current_match = updated_matches[current_match.index]
		self.search_input.current_match = updated_current_match
		self.search_input.matches = updated_matches
		self.search_input:apply_highlights()
	end
end

function SearchAndReplaceDialog:show()
	self.search_input:show()
	self.replace_input:show()
	self.visible = true
end

function SearchAndReplaceDialog:hide()
	self.search_input:hide()
	self.replace_input:hide()
	self.visible = false
end

return SearchAndReplaceDialog
