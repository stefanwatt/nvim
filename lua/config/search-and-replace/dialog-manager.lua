local match = require("config.search-and-replace.match")
local highlight = require("config.search-and-replace.highlight")
local constants = require("config.search-and-replace.constants")

---@class SearchDialog
---@field value? string
---@field matches? Match[]
---@field current_match? Match
---@field source_buf_id? number
---@field source_win_id? number
---@field nui_input? NuiInput
---@field visible boolean
---@field mounted boolean
local search_dialog = { visible = false }

---@class ReplaceDialog
---@field value? string
---@field source_buf_id? number
---@field source_win_id? number
---@field nui_input? NuiInput
---@field visible boolean
---@field mounted boolean
local replace_dialog = { visible = false }

---@param popup_options nui_popup_options
---@return NuiInput
function create_search_input(popup_options)
	return require("nui.input")(popup_options, {
		on_change = on_search_input_change,
	})
end

---@param value string
function on_search_input_change(value)
	search_dialog.value = value
	search_dialog.matches = match.get_matches(value, search_dialog.source_buf_id)
	if not search_dialog.matches then
		print("no matches after on_change")
		return
	end
	search_dialog.current_match =
		match.get_closest_match_after_cursor(search_dialog.matches, search_dialog.source_win_id)
	if not search_dialog.current_match then
		print("no current match after on_change")
		return
	end
	highlight.highlight_matches(search_dialog.matches, search_dialog.current_match, search_dialog.source_buf_id)
end

---@param value string
function set_search_term(value)
	if not value then
		return
	end
	search_dialog.value = value
	vim.api.nvim_buf_set_lines(search_dialog.nui_input.bufnr, 0, 1, false, { value })
	update_matches(value)
end

---@param value? string
function update_matches(value)
	search_dialog.matches = match.get_matches(value or search_dialog.value or "", search_dialog.source_buf_id)
	local closest_match = match.get_closest_match_after_cursor(search_dialog.matches, search_dialog.source_win_id)
	update_current_match(closest_match)
	highlight.highlight_matches(search_dialog.matches, closest_match, search_dialog.source_buf_id)
end

function apply_search_input_keymaps()
	search_dialog.nui_input:map("i", "<CR>", function()
		local updated_current_match = match.get_next_match(search_dialog.current_match, search_dialog.matches)
		print("next match: " .. tostring(vim.inspect(updated_current_match)))
		update_current_match(updated_current_match)
		highlight.highlight_matches(search_dialog.matches, search_dialog.current_match, search_dialog.source_buf_id)
	end, { noremap = true })

	search_dialog.nui_input:map("i", "<TAB>", function()
		focus_dialog(replace_dialog)
	end, { noremap = true })
	search_dialog.nui_input:map("n", "<TAB>", function()
		focus_dialog(replace_dialog)
	end, { noremap = true })
end

---@param current_match? Match
function update_current_match(current_match)
	if not current_match then
		return
	end
	search_dialog.current_match = current_match
	if not match.is_match_in_viewport(current_match, search_dialog.source_win_id) then
		vim.api.nvim_win_set_cursor(search_dialog.source_win_id, { current_match.start_row, current_match.start_col })
		vim.api.nvim_set_current_win(search_dialog.source_win_id)
		vim.api.nvim_command("normal zz")
		focus_dialog(search_dialog)
	end
end

function init_search_dialog()
	local popup_options = constants.get_search_dialog_popup_options()
	search_dialog.nui_input = create_search_input(popup_options)
	apply_search_input_keymaps()
end

------------------------------------------------------------------------------------------
-----------------------------------REPLACE------------------------------------------------
------------------------------------------------------------------------------------------

---@param popup_options nui_popup_options
---@return NuiInput
function create_replace_input(popup_options)
	return require("nui.input")(popup_options, {
		on_change = on_replace_input_change,
	})
end

---@param value string
function on_replace_input_change(value)
	replace_dialog.value = value
end

function apply_replace_input_keymaps()
	replace_dialog.nui_input:map("i", "<CR>", function()
		replace_current_match()
	end, { noremap = true })

	replace_dialog.nui_input:map("i", "<TAB>", function()
		focus_dialog(search_dialog)
	end, { noremap = true })
	replace_dialog.nui_input:map("n", "<TAB>", function()
		focus_dialog(search_dialog)
	end, { noremap = true })
end

function replace_current_match()
	local current_match = search_dialog.current_match
	local replace_term = replace_dialog.value
	if replace_term and current_match then
		match.replace_current_match(replace_term, current_match, replace_dialog.source_buf_id)
		local updated_matches = match.get_matches(search_dialog.value, search_dialog.source_buf_id)
		local updated_current_match = updated_matches[current_match.index]
		update_current_match(updated_current_match)
		search_dialog.matches = updated_matches
		highlight.highlight_matches(search_dialog.matches, updated_current_match, search_dialog.source_buf_id)
	end
end

function init_replace_dialog()
	local popup_options = constants.get_replace_dialog_popup_options()
	replace_dialog.nui_input = create_replace_input(popup_options)
	apply_replace_input_keymaps()
end

------------------------------------------------------------------------------------------
-----------------------------------GENERAL------------------------------------------------
------------------------------------------------------------------------------------------

---@param dialog SearchDialog | ReplaceDialog
function focus_dialog(dialog)
	local col = dialog.value ~= nil and #dialog.value + 1 or 1
	vim.api.nvim_set_current_win(dialog.nui_input.winid)
	if dialog.value ~= nil then
		vim.api.nvim_win_set_cursor(dialog.nui_input.winid, { 1, #dialog.value })
	end
	vim.api.nvim_command("startinsert!")
end

---@param dialog SearchDialog | ReplaceDialog
function show_dialog(dialog)
	if dialog.visible then
		return
	end
	if not dialog.mounted then
		dialog.nui_input:mount()
		dialog.mounted = true
		dialog.visible = true
		return
	end
	dialog.nui_input:update_layout({
		relative = {
			winid = dialog.source_win_id,
		},
	})
	dialog.nui_input:show()
	dialog.visible = true
	focus_dialog(dialog)
	if dialog.matches then
		highlight.highlight_matches(dialog.matches, dialog.current_match, dialog.source_buf_id)
	end
end

---@param dialog SearchDialog | ReplaceDialog
function hide_dialog(dialog)
	if not dialog.mounted or not dialog.visible then
		return
	end
	dialog.nui_input:hide()
	dialog.visible = false
	if dialog.matches then
		print("clear highlighths;source_buf_id=" .. tostring(dialog.source_buf_id))
		vim.api.nvim_buf_clear_namespace(search_dialog.source_buf_id, -1, 0, -1)
	end
end

------------------------------------------------------------------------------------------
-----------------------------------EXPORTS------------------------------------------------
------------------------------------------------------------------------------------------
local M = {}

---@param source_buf_id number
---@param source_win_id number
---@param prefilled_search_term? string
M.toggle_search_dialog = function(source_buf_id, source_win_id, prefilled_search_term)
	if not search_dialog.nui_input then
		init_search_dialog()
	end
	if not search_dialog.visible then
		search_dialog.source_buf_id = source_buf_id
		search_dialog.source_win_id = source_win_id
		show_dialog(search_dialog)
	else
		hide_dialog(search_dialog)
	end
end

---@param source_buf_id number
---@param source_win_id number
---@param prefilled_search_term? string
M.toggle_replace_dialog = function(source_buf_id, source_win_id, prefilled_search_term)
	if not search_dialog.nui_input then
		init_search_dialog()
	end

	if not replace_dialog.nui_input then
		init_replace_dialog()
	end

	if replace_dialog.visible then
		hide_dialog(replace_dialog)
		hide_dialog(search_dialog)
		return
	end

	if not search_dialog.visible then
		search_dialog.source_buf_id = source_buf_id
		search_dialog.source_win_id = source_win_id
		show_dialog(search_dialog)
	end
	show_dialog(replace_dialog)
end
return M
