---@class Match
---@field start_col number
---@field start_row number
---@field end_row number
---@field end_col number
---@field index number

local utils = require("config.search-and-replace.utils")
---@class SearchInput
---@field mounted boolean
---@field visible boolean
---@field standalone boolean
---@field original_buf_id? number
---@field original_window_id? number
---@field search_term? string
---@field current_match? Match
---@field matches? Match[]
---@field nui_input? NuiInput
---@field popup_options? nui_popup_options
local SearchInput = {}

SearchInput.__index = SearchInput

---@type SearchInput
local default_props = {
	mounted = false,
	visible = false,
	standalone = true, -- is the search input being used on its own or in conjunction with a replace input?
	original_buf_id = nil,
	original_window_id = nil,
	search_term = "",
	current_match = nil,
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

---@param original_buf_id number
---@param original_window_id number
---@return SearchInput
function SearchInput.new(original_buf_id, original_window_id, standalone)
	local props = default_props
	local self = setmetatable(props, SearchInput)
	local outer_self = self
	self.original_buf_id = original_buf_id
	self.original_window_id = original_window_id
	if standalone ~= nil then
		self.standalone = standalone
	end

	self.nui_input = require("nui.input")(props.popup_options, {
		on_change = function(value)
			outer_self.search_term = value
			outer_self.matches = utils.get_matches(value, outer_self.original_buf_id)
			outer_self.current_match = outer_self.matches[1]
			outer_self:apply_highlights()
		end,
	})

	self.nui_input:map("i", "<CR>", function()
		if outer_self.current_match == nil or #outer_self.matches == 0 then
			print("no matches")
			return
		end
		if #outer_self.matches == 1 then
			print("no other matches")
			return
		end

		utils.apply_highlight(outer_self.current_match, outer_self.original_buf_id, "Search")
		outer_self.current_match = outer_self:get_next_match(outer_self.current_match.index)
		outer_self:apply_highlights()
	end, { noremap = true })

	-- self.nui_input:map("i", "<Esc>", function()
	--   self.nui_input:hide()
	-- end, { noremap = true })
	return self
end

function SearchInput:apply_highlights()
	vim.api.nvim_buf_clear_namespace(self.original_buf_id, -1, 0, -1) -- Clear existing highlights
	for _, match in ipairs(self.matches) do
		local hl_group = "Search"
		if match == self.current_match then
			hl_group = "IncSearch"
		end
		utils.apply_highlight(match, self.original_buf_id, hl_group)
	end
end
---@param original_buf_id number
function SearchInput:set_original_buf_id(original_buf_id)
	self.original_buf_id = original_buf_id
end

---@param original_window_id number
function SearchInput:set_original_window_id(original_window_id)
	self.original_window_id = original_window_id
end

function SearchInput:show()
	-- TODO dont need to run this logic if standalone == false
	if self.mounted then
		self.nui_input:show()
		self:focus()
		return
	end
	self.nui_input:mount()
	self.mounted = true
	self.visible = true
end

function SearchInput:hide()
	if not self.mounted then
		self.nui_input:hide()
		return
	end
	self.nui_input:unmount()
	self.mounted = false
	self.visible = false
end

---@return nui_popup_options
function SearchInput:get_popup_opts()
	return self.popup_options
end

function SearchInput:focus()
	local col = self.search_term ~= nil and #self.search_term + 1 or 1
	vim.api.nvim_set_current_win(self.nui_input.winid)
	if self.search_term ~= nil then
		vim.api.nvim_win_set_cursor(self.nui_input.winid, { 1, #self.search_term })
	end
	vim.api.nvim_command("startinsert!")
end

---@param current_index number
function SearchInput:get_next_match(current_index)
	if #self.matches[current_index] ~= nil then
		return current_index + 1 > #self.matches and self.matches[1] or self.matches[current_index + 1]
	end
end

---@param match Match
function SearchInput:remove_match(match)
	for i, m in ipairs(self.matches) do
		if m == match then
			table.remove(self.matches, i)
			self.current_match = self:get_next_match(i)
			break
		end
	end
	self:apply_highlights()
end

return SearchInput
