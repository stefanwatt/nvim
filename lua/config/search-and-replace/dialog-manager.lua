local constants = require("config.search-and-replace.constants")
---@class SandrPopup
---@field value? string
---@field mounted boolean
---@field nui_popup? NuiPopup
---@field source_win_id? number

---@type boolean
local visible = false
------------------------------------------------------------------------------------------
-----------------------------------SEARCH-------------------------------------------------
------------------------------------------------------------------------------------------
---@type SandrPopup
local search_popup = { mounted = false }

local function init_search_popup()
	local popup_options = constants.get_search_popup_options()
	search_popup.nui_popup = require("nui.popup")(popup_options)
end
---@type SandrPopup
local replace_popup = { mounted = false }

------------------------------------------------------------------------------------------
-----------------------------------REPLACE------------------------------------------------
------------------------------------------------------------------------------------------
local function init_replace_popup()
	local popup_options = constants.get_replace_popup_options()
	replace_popup.nui_popup = require("nui.popup")(popup_options)
end

------------------------------------------------------------------------------------------
-----------------------------------GENERAL------------------------------------------------
------------------------------------------------------------------------------------------

---@param popup SandrPopup
local function show_popup(popup)
	if visible then
		return
	end
	if not popup.mounted then
		popup.nui_popup:mount()
		popup.mounted = true
		return
	end

	popup.nui_popup:show()
end

---@param popup SandrPopup
local function hide_popup(popup)
	if not popup.mounted or not visible then
		return
	end
	popup.nui_popup:hide()
end

---@param cmdline_text string
---@return string: search_term
---@return string: replace_term
---@return string: flags
local function parse_cmdline_text(cmdline_text)
	local search_term, replace_term, flags = cmdline_text:match("s/([^/]+)/([^/]+)/([^/]*)")
	return search_term, replace_term, flags
end

local function redraw()
	local search_popup_options = constants.get_search_popup_options()
	local replace_popup_options = constants.get_replace_popup_options()
	vim.schedule(function()
		search_popup.nui_popup:update_layout({
			relative = {
				winid = search_popup.source_win_id,
			},
		})
		replace_popup.nui_popup:update_layout({
			winid = replace_popup.source_win_id,
		})
	end)
end

---@param popup SandrPopup
---@param text string
local function set_text_on_popup(popup, text)
	if popup.value == text then
		return
	end
	popup.value = text
	vim.api.nvim_buf_set_lines(popup.nui_popup.bufnr, 0, -1, false, { text })
	-- vim.api.nvim_input(" <bs>")
	redraw()
end

---@param text string
---@param cursor_pos number
local function get_cursor_positions(text, cursor_pos)
	local search_term, replace_term, flags = parse_cmdline_text(text)
	local search_term_start, search_term_end = text:find(search_term)
	local replace_term_start, replace_term_end = text:find(replace_term)
	local search_term_cursor_pos = -1
	local replace_term_cursor_pos = -1
	if cursor_pos >= search_term_start and cursor_pos <= search_term_end then
		search_term_cursor_pos = cursor_pos - search_term_start
	end
	if cursor_pos >= replace_term_start and cursor_pos <= replace_term_end then
		replace_term_cursor_pos = cursor_pos - replace_term_start
	end
	return search_term_cursor_pos, replace_term_cursor_pos
end

---@param buffer number
---@param cursor_pos number
local function draw_cursor(buffer, cursor_pos)
	local cursor_line = 0 -- Assuming the command line is on the first line of the buffer
	local ns_id = vim.api.nvim_create_namespace("")
	vim.api.nvim_buf_clear_namespace(buffer, ns_id, 0, -1)
	vim.api.nvim_buf_add_highlight(buffer, ns_id, "Cursor", cursor_line, cursor_pos, cursor_pos + 1)
end
------------------------------------------------------------------------------------------
-----------------------------------EXPORTS------------------------------------------------
------------------------------------------------------------------------------------------
local M = {}

M.hide_replace_popup = function()
	hide_popup(search_popup)
	hide_popup(replace_popup)
	visible = false
end

---@param source_win_id number
M.toggle_replace_popup = function(source_win_id)
	if not search_popup.nui_popup then
		init_search_popup()
	end

	if not replace_popup.nui_popup then
		init_replace_popup()
	end

	if visible then
		hide_popup(search_popup)
		hide_popup(replace_popup)
		visible = false
		return
	end
	show_popup(replace_popup)
	visible = true
end

--- @param text string
--- @param cursor_pos number
--- @param prefix string
local count = 1
M.update = function(text, cursor_pos, prefix)
	local search_term, replace_term, flags = parse_cmdline_text(text)

	local search_win = require("config.utils").get_window_of_buffer(search_popup.nui_popup.bufnr)
	local replace_win = require("config.utils").get_window_of_buffer(replace_popup.nui_popup.bufnr)
	if not search_win or not replace_win then
		print(tostring(count))
		count = count + 1
		print("visible=" .. tostring(visible))
		print("window not found")
		show_popup(search_popup)
		show_popup(replace_popup)
		visible = true
	end

	if not search_win or not replace_win then
		print("wtf still no window")
		return
	end

	print(
		'setting text "'
			.. search_term
			.. '" on search buffer '
			.. tostring(search_popup.nui_popup.bufnr)
			.. " window "
			.. tostring(search_win)
	)
	set_text_on_popup(search_popup, search_term)
	print(
		'setting text "'
			.. replace_term
			.. '" on replace buffer '
			.. tostring(replace_popup.nui_popup.bufnr)
			.. "window "
			.. tostring(replace_win)
	)
	set_text_on_popup(replace_popup, replace_term)
	local search_term_cursor_pos, replace_term_cursor_pos = get_cursor_positions(text, cursor_pos)
	if search_term_cursor_pos ~= -1 then
		draw_cursor(search_popup.nui_popup.bufnr, search_term_cursor_pos)
	end
	if replace_term_cursor_pos ~= -1 then
		draw_cursor(replace_popup.nui_popup.bufnr, replace_term_cursor_pos)
	end
end

return M
