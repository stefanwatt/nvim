local utils = require("config.search-and-replace.utils")
---@class SearchInput
---@field mounted boolean
---@field visible boolean
---@field standalone boolean
---@field original_buf_id? number
---@field original_window_id? number
---@field value? string
---@field current_match? Match
---@field matches? Match[]
---@field nui_input? NuiInput
---@field popup_options? nui_popup_options
local SearchInput = {}

SearchInput.__index = SearchInput

---@param original_buf_id number
---@param original_window_id number
---@return SearchInput
function SearchInput.new(original_buf_id, original_window_id, standalone, prefilled_search_term)
	local props = require("config.search-and-replace.constants").get_search_input_props()
	local self = setmetatable(props, SearchInput)
	local outer_self = self
	self.original_buf_id = original_buf_id
	self.original_window_id = original_window_id
	self.value = prefilled_search_term
	if standalone ~= nil then
		self.standalone = standalone
	end
	self.nui_input = require("nui.input")(props.popup_options, {
		on_change = function(value)
			outer_self.value = value
			outer_self:update_matches(value)
		end,
	})
	self.nui_input:map("i", "<CR>", function()
		outer_self:go_to_next_match()
	end, { noremap = true })
	return self
end

function SearchInput:go_to_next_match()
	if self.current_match == nil or #self.matches == 0 then
		print("no matches")
		return
	end
	if #self.matches == 1 then
		print("no other matches")
		return
	end

	utils.apply_highlight(self.current_match, self.original_buf_id, "Search")
	local next_match = self:get_next_match(self.current_match.index)
	self:set_current_match(next_match)
	self:apply_highlights()
end

function SearchInput:apply_highlights()
	vim.api.nvim_buf_clear_namespace(self.original_buf_id, -1, 0, -1) -- Clear existing highlights
	if not self.value or #self.value == 0 or self.matches == nil or #self.matches == 0 then
		return
	end
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
	if not self.mounted then
		self.nui_input:mount()
		self.mounted = true
		self.visible = true
		return
	end
	self.nui_input:update_layout({
		relative = {
			winid = self.original_window_id,
		},
	})
	self.nui_input:show()
	self.visible = true
	self:focus()
end

function SearchInput:hide()
	if not self.mounted then
		return
	end
	self.nui_input:hide()
	self.visible = false
end

---@return nui_popup_options
function SearchInput:get_popup_opts()
	return self.popup_options
end

function SearchInput:focus()
	local col = self.value ~= nil and #self.value + 1 or 1
	vim.api.nvim_set_current_win(self.nui_input.winid)
	if self.value ~= nil then
		vim.api.nvim_win_set_cursor(self.nui_input.winid, { 1, #self.value })
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
			self:set_current_match(self:get_next_match(i))
			break
		end
	end
	self:apply_highlights()
end

---@param match Match
function SearchInput:set_current_match(match)
	self.current_match = match
	if match and not utils.is_match_in_viewport(match, self.original_window_id) then
		vim.api.nvim_win_set_cursor(self.original_window_id, { match.start_row, match.start_col })
		vim.api.nvim_set_current_win(self.original_window_id)
		vim.api.nvim_command("normal zz")
		self:focus()
	end
end

---@param search_term? string
function SearchInput:set_search_term(search_term)
	if not search_term then
		return
	end
	self.value = search_term
	vim.api.nvim_buf_set_lines(self.nui_input.bufnr, 0, 1, false, { search_term })
	self:update_matches(search_term)
end

---@param search_term? string
function SearchInput:update_matches(search_term)
	self.matches = utils.get_matches(search_term or self.value or "", self.original_buf_id)
	local closest_match = utils.get_closest_match_after_cursor(self.matches, self.original_window_id)
	self:set_current_match(closest_match)
	self:apply_highlights()
end

return SearchInput
