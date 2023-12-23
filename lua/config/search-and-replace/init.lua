local Layout = require("nui.layout")
local event = require("nui.utils.autocmd").event
local utils = require("config.search-and-replace.utils")
local SearchInput = require("config.search-and-replace.search-input")
local ReplaceInput = require("config.search-and-replace.replace-input")

local last_search_term = nil -- Global variable to store the last search term
local Input = require("nui.input")

local keymap = require("config.utils").keymap

local search_input = SearchInput.new()
local replace_input = ReplaceInput.new()
keymap("n", "<C-f>", function()
	local original_buf_id = vim.api.nvim_get_current_buf()
	local original_window_id = vim.api.nvim_get_current_win()
	search_input:set_original_buf_id(original_buf_id)
	search_input:set_original_window_id(original_window_id)
	search_input:show()
end, { noremap = true, silent = true })

keymap("n", "<C-h>", function()
	local original_buf_id = vim.api.nvim_get_current_buf()
	local original_window_id = vim.api.nvim_get_current_win()
	search_input:set_original_buf_id(original_buf_id)
	search_input:set_original_window_id(original_window_id)
	replace_input:set_original_buf_id(original_buf_id)
	replace_input:set_original_window_id(original_window_id)
	search_input:show()
	replace_input:show()
end, { noremap = true, silent = true })
