-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup("nix"),
	pattern = "*.nix",
	callback = function(args)
		vim.fn.jobstart({ "nixfmt", args.file }, {
			stdout_buffered = true,
			on_stdout = function(_, data)
				if data then
					vim.cmd("checktime")
				end
			end,
		})
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup("persistence"),
	pattern = "*",
	callback = function()
		require("persistence").save()
	end,
})

-- vim.api.nvim_create_autocmd({ "VimEnter", "WinNew", "WinClosed" }, {
-- 	group = augroup("NoNeckPain"),
-- 	pattern = "*",
-- 	callback = function()
-- 		if #vim.api.nvim_list_wins() > 1 then
-- 			NoNeckPain.disable()
-- 		else
-- 			NoNeckPain.enable()
-- 		end
-- 	end,
-- })
