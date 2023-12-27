function ReplaceInput:focus()
	local col = self.value ~= nil and #self.value + 1 or 1
	vim.api.nvim_set_current_win(self.nui_input.winid)
	if self.value ~= nil then
		vim.api.nvim_win_set_cursor(self.nui_input.winid, { 1, #self.value })
	end
	vim.api.nvim_command("startinsert!")
end

return ReplaceInput
