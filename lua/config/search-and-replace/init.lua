local Layout = require("nui.layout")
local dialog_manager = require("config.search-and-replace.dialog-manager")
local event = require("nui.utils.autocmd").event
local utils = require("config.search-and-replace.utils")
local Input = require("nui.input")
require("config.search-and-replace.commands")

-- TODO
-- 1. broken after toggling off then on
-- 2. you need to be able to search first(ctrl+f) then hit ctrl+h and have the search term and matches
--    carry over to start replacing
-- 3. Add replace modes/flags (regex, ignore case, match whole word)
--    toggle modes with keymap
--    show mode indicator in the dialog
-- 4. when original buffer is updated -> update matches
-- 5. is multi-line replace working?

vim.keymap.set("n", "<C-f>", function()
	local source_buf_id = vim.api.nvim_get_current_buf()
	local source_win_id = vim.api.nvim_get_current_win()
	dialog_manager.toggle_search_dialog(source_buf_id, source_win_id)
end, { noremap = true, silent = true })
vim.keymap.set("i", "<C-f>", function()
	local source_buf_id = vim.api.nvim_get_current_buf()
	local source_win_id = vim.api.nvim_get_current_win()
	dialog_manager.toggle_search_dialog(source_buf_id, source_win_id)
end, { noremap = true, silent = true })
vim.keymap.set("v", "<C-f>", function()
	local selection = utils.buf_vtext()
	local source_buf_id = vim.api.nvim_get_current_buf()
	local source_win_id = vim.api.nvim_get_current_win()
	dialog_manager.toggle_search_dialog(source_buf_id, source_win_id, selection)
end, { noremap = true, silent = true })

vim.keymap.set("n", "<C-h>", function()
	local source_buf_id = vim.api.nvim_get_current_buf()
	local source_win_id = vim.api.nvim_get_current_win()
	dialog_manager.toggle_replace_dialog(source_buf_id, source_win_id)
end, { noremap = true, silent = true })
vim.keymap.set("i", "<C-h>", function()
	local source_buf_id = vim.api.nvim_get_current_buf()
	local source_win_id = vim.api.nvim_get_current_win()
	dialog_manager.toggle_replace_dialog(source_buf_id, source_win_id)
end, { noremap = true, silent = true })
vim.keymap.set("v", "<C-h>", function()
	local selection = utils.buf_vtext()
	local source_buf_id = vim.api.nvim_get_current_buf()
	local source_win_id = vim.api.nvim_get_current_win()
	dialog_manager.toggle_replace_dialog(source_buf_id, source_win_id, selection)
end, { noremap = true, silent = true })
