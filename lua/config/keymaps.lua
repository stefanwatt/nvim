require("config.substitute")
local opts = { silent = true }
local utils = require("config.utils")
local nvim_float = utils.NvimFloat

vim.keymap.set("n", "<BS>", "ciw", opts)
vim.keymap.set("n", "<CR>", function()
	local buftype = vim.api.nvim_buf_get_option(0, "buftype")
	if buftype == "quickfix" then
		return
	end
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_input("ggyG")
	vim.schedule(function()
		vim.api.nvim_win_set_cursor(0, cursor_pos)
	end)
end, opts)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function(event)
		vim.keymap.set({ "n", "i" }, "<C-p>", "<cmd>cprev<CR>", opts)
		vim.keymap.set({ "n", "i" }, "<C-n>", "<cmd>cnext<CR>", opts)
	end,
})
vim.keymap.set("n", "<leader>q", "<cmd>q!<CR>", opts)
vim.keymap.set("n", "<leader>w", "<cmd>w!<CR>", opts)
vim.keymap.set("n", "<C-s>", "<cmd>wall<CR>", opts)
vim.keymap.set("n", "<C-x>", utils.MoveBufferToOppositeWindow, opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

vim.keymap.set("v", ":", function()
	vim.cmd('normal! "vy')
	local text = vim.fn.getreg("v")
	vim.api.nvim_input(":<C-u>" .. text)
end, { noremap = true, silent = true, desc = "Open cmdline with visual selection" })

vim.keymap.set("v", "/", function()
	vim.cmd('normal! "vy')
	local text = vim.fn.getreg("v")
	vim.api.nvim_input("/<C-u>" .. text)
end, { noremap = true, silent = true, desc = "Search with visual selection" })

vim.keymap.set("v", "=", function()
	vim.cmd('normal! "vy')
	local text = vim.fn.getreg("v")
	vim.api.nvim_input(":<C-u>" .. "=" .. text)
end, { noremap = true, silent = true, desc = "lua command with visual selection" })

vim.keymap.set("n", "<leader>r", ":%s///gci<Left><Left><Left><Left><Left>", opts)

vim.keymap.set("v", "<leader>r", function()
	vim.cmd('normal! "vy')
	local text = vim.fn.getreg("v")
	vim.api.nvim_input(":%s/" .. text .. "//gci<Left><Left><Left><Left>")
end, opts)

vim.keymap.set("n", "<leader>v", "<cmd>vsplit<CR>", opts)
vim.keymap.set("n", "<leader>V", function()
	utils.exec("wezterm cli split-pane --horizontal")
end, opts)
vim.keymap.set("n", "<leader>T", function()
	utils.exec("wezterm cli split-pane --bottom --percent 30")
end, opts)

vim.keymap.set("n", "<leader>gg", function()
	nvim_float("lazygit")
end, opts)

-- Navigate buffers
vim.keymap.set("n", "<S-Right>", "<cmd>bnext<CR>", opts)
vim.keymap.set("n", "<S-Left>", "<cmd>bprevious<CR>", opts)
vim.keymap.set("n", "gb", "<C-o>", opts)
vim.keymap.set("n", "db", "vbd", opts)
vim.keymap.set("n", "cb", "vbc", opts)
vim.keymap.set("v", "p", '"_dP', opts)
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)
vim.keymap.set("n", "<leader><leader>x", "<cmd>so %<cr> :lua print('file reloaded')<cr>", opts)
vim.keymap.set("n", "s", function()
	require("flash").jump({
		search = {
			mode = function(str)
				return "\\<" .. str
			end,
		},
	})
end, { silent = true, noremap = true })

local function auto_indent_new_line()
	if vim.bo.filetype == "go" then
		local cur_line = vim.api.nvim_get_current_line()
		local indent = string.match(cur_line, "^%s*")
		local last_char = string.match(cur_line, ".(.)%s*$")

		if last_char == "(" or last_char == "{" or last_char == "[" then
			-- Add an extra level of indentation for opening braces/brackets
			indent = indent .. "\t"
		end

		vim.api.nvim_feedkeys("o" .. indent, "n", false)
	else
		vim.api.nvim_feedkeys("o", "n", false)
	end
end
vim.keymap.set("n", "o", auto_indent_new_line, opts)

vim.api.nvim_set_keymap('n', ']b', '<Plug>JumpDiffCharNextStart', { noremap = false })
vim.api.nvim_set_keymap('n', '[b', '<Plug>JumpDiffCharPrevStart', { noremap = false })
