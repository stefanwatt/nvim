local Layout = require("nui.layout")
local event = require("nui.utils.autocmd").event
local utils = require("config.search-and-replace.utils")
local SearchInput = require("config.search-and-replace.search-input")
local ReplaceInput = require("config.search-and-replace.replace-input")
local SearchAndReplaceDialog = require("config.search-and-replace.search-and-replace-dialog")

local last_search_term = nil -- Global variable to store the last search term
local Input = require("nui.input")

local keymap = require("config.utils").keymap

--foo
--barfoobarfoo
--bazfoobaz
--foo

-- TODO
-- when opening search and replace dialog, set cursor on search input
-- refactor
-- when original buffer is updated -> update matches
-- why dose tab binding no longer work after hiding+showing the dialog?

---@type SearchInput
local search_input = nil
---@type SearchAndReplaceDialog
local search_and_replace_dialog = nil

local function toggle_search_input()
	if search_input and search_input.visible then
		search_input:hide()
		return
	end
	local original_buf_id = vim.api.nvim_get_current_buf()
	local original_window_id = vim.api.nvim_get_current_win()
	if not search_input then
		search_input = SearchInput.new(original_buf_id, original_window_id)
	end
	search_input:set_original_buf_id(original_buf_id)
	search_input:set_original_window_id(original_window_id)
	search_input:show()
end
keymap("n", "<C-f>", function()
	toggle_search_input()
end, { noremap = true, silent = true })

keymap("i", "<C-f>", function()
	toggle_search_input()
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
