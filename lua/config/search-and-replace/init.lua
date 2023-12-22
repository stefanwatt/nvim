local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local utils = require("config.search-and-replace.utils")
local SearchInput = require("config.search-and-replace.search-input")

local last_search_term = nil -- Global variable to store the last search term
local Input = require("nui.input")

local keymap = require("config.utils").keymap

local search_input = SearchInput.new()
keymap("n", "<C-f>", function()
	local original_buf_id = vim.api.nvim_get_current_buf()
	local orginal_window_id = vim.api.nvim_get_current_win()
	search_input:set_original_buf_id(original_buf_id)
	search_input:set_original_window_id(orginal_window_id)
	search_input:show()
end, { noremap = true, silent = true })

-- keymap("n", "<C-h>", function()
-- 	show_search_and_replace_dialog()
-- end, { noremap = true, silent = true })
