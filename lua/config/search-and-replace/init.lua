local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local utils = require("config.search-and-replace.utils")
local my_nui = require("config.search-and-replace.nui")
local SearchInput = require("config.search-and-replace.search-input")

local last_search_term = nil -- Global variable to store the last search term
local Input = require("nui.input")

function show_search_and_replace_dialog()
	local original_buf_nr = vim.api.nvim_get_current_buf()
	local orginal_window = vim.api.nvim_get_current_win()

	local input = Input(my_nui.replace_input_options, {
		on_change = function(searchTerm)
			last_search_term = searchTerm
			utils.highlightMatches(searchTerm, original_buf_nr)
		end,
		-- on_submit = function(searchTerm)
		-- 	utils.jumpToNextMatch(lastSearchTerm, originalBufNr)
		-- end,
	})
	input:map("i", "<CR>", function()
		utils.jumpToNextMatch(last_search_term, original_buf_nr, orginal_window)
	end, { noremap = true })

	input:map("i", "<Esc>", function()
		input:hide()
	end, { noremap = true })

	input:mount()
end

local keymap = require("config.utils").keymap

local search_input = SearchInput.new()
keymap("n", "<C-f>", function()
	local original_buf_id = vim.api.nvim_get_current_buf()
	local orginal_window_id = vim.api.nvim_get_current_win()
	search_input:set_original_buf_id(original_buf_id)
	search_input:set_original_window_id(orginal_window_id)
	search_input:show()
end, { noremap = true, silent = true })

keymap("n", "<C-h>", function()
	show_search_and_replace_dialog()
end, { noremap = true, silent = true })
