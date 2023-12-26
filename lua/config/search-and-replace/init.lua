local Layout = require("nui.layout")
local event = require("nui.utils.autocmd").event
local utils = require("config.search-and-replace.utils")
local SearchInput = require("config.search-and-replace.search-input")
local ReplaceInput = require("config.search-and-replace.replace-input")
local SearchAndReplaceDialog = require("config.search-and-replace.search-and-replace-dialog")

local last_search_term = nil -- Global variable to store the last search term
local Input = require("nui.input")

local keymap = require("config.utils").keymap

-- TODO
-- 1. refactor
-- 2. you need to be able to search first(ctrl+f) then hit ctrl+h and have the search term and matches
--    carry over to start replacing
-- 3. Add replace modes/flags (regex, ignore case, match whole word)
--    toggle modes with keymap
--    show mode indicator in the dialog
-- 4. when original buffer is updated -> update matches
-- 5. is multi-line replace working?

---@type SearchInput
local search_input = nil
---@type SearchAndReplaceDialog
local search_and_replace_dialog = nil

---@param prefilled_search_term? string
local function toggle_search_input(prefilled_search_term)
	if search_input and search_input.visible then
		search_input:hide()
		return
	end
	local original_buf_id = vim.api.nvim_get_current_buf()
	local original_window_id = vim.api.nvim_get_current_win()
	if not search_input then
		search_input = SearchInput.new(original_buf_id, original_window_id, true, prefilled_search_term)
	end
	search_input:set_original_buf_id(original_buf_id)
	search_input:set_original_window_id(original_window_id)
	search_input:set_search_term(prefilled_search_term)
	search_input:show()
end
keymap("n", "<C-f>", function()
	toggle_search_input()
end, { noremap = true, silent = true })

keymap("i", "<C-f>", function()
	toggle_search_input()
end, { noremap = true, silent = true })

keymap("v", "<C-f>", function()
	-- get current selection and set it as the search term
	local selection = require("config.utils").buf_vtext()
	toggle_search_input(selection)
end, { noremap = true, silent = true })

local function toggle_search_and_replace_dialog()
	if search_and_replace_dialog and search_and_replace_dialog.visible then
		search_and_replace_dialog:hide()
		return
	end
	local original_buf_id = vim.api.nvim_get_current_buf()
	local original_window_id = vim.api.nvim_get_current_win()
	if not search_and_replace_dialog then
		search_and_replace_dialog = SearchAndReplaceDialog.new(original_buf_id, original_window_id)
	end
	search_and_replace_dialog:show()
end

keymap("n", "<C-h>", function()
	toggle_search_and_replace_dialog()
end, { noremap = true, silent = true })

keymap("i", "<C-h>", function()
	toggle_search_and_replace_dialog()
end, { noremap = true, silent = true })
