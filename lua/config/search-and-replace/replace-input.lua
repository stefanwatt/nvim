local utils = require("config.search-and-replace.utils")

search_term = ""
local replace_input_options = {
	enter = false,
	focusable = true,
	border = {
		style = "rounded",
		text = {
			top = "Replace",
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
}
function show_search_and_replace_dialog()
	local original_buf_nr = vim.api.nvim_get_current_buf()
	local orginal_window = vim.api.nvim_get_current_win()

	local input = require("nui.input")(replace_input_options, {
		on_change = function(searchTerm)
			search_term = searchTerm
			utils.highlightMatches(searchTerm, original_buf_nr)
		end,
		-- on_submit = function(searchTerm)
		-- 	utils.jumpToNextMatch(lastSearchTerm, originalBufNr)
		-- end,
	})
	input:map("i", "<CR>", function()
		utils.jumpToNextMatch(search_term, original_buf_nr, orginal_window)
	end, { noremap = true })

	input:map("i", "<Esc>", function()
		input:hide()
	end, { noremap = true })

	input:mount()
end
