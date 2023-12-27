local dialog_manager = require("config.search-and-replace.dialog-manager")
local utils = require("config.search-and-replace.utils")

vim.api.nvim_create_user_command("SearchDialogToggle", function(opts)
	local selection = nil
	if opts.args == "visual" then
		selection = utils.buf_vtext()
	end
	local source_buf_id = vim.api.nvim_get_current_buf()
	local source_win_id = vim.api.nvim_get_current_win()
	dialog_manager.toggle_dialog("search", selection, source_buf_id, source_win_id)
end, {
	nargs = "?",
})

vim.api.nvim_create_user_command("SearchAndReplaceDialogToggle", function()
	local source_buf_id = vim.api.nvim_get_current_buf()
	local source_win_id = vim.api.nvim_get_current_win()
	dialog_manager.toggle_dialog("replace", nil, source_buf_id, source_win_id)
end, {
	nargs = 0,
})
