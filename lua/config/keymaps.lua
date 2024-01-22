-- Silent keymap option
local opts = { silent = true }

-- Normal --
vim.keymap.set("n", "<BS>", "ciw", opts)
vim.keymap.set("n", "<CR>", "ggVGy", opts)
vim.keymap.set("n", "<leader>q", ":q!<CR>", opts)
vim.keymap.set("n", "<leader>w", ":w!<CR>", opts)
vim.keymap.set("n", "<C-s>", ":wall<CR>", opts)
vim.keymap.set("n", "<C-x>", require("config.utils").MoveBufferToOppositeWindow, opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
-- vim.keymap.set("n", "<C-h>", function()
-- 	require("sandr").search_and_replace({})
-- end, {})
-- vim.keymap.set("v", "<C-h>", function()
-- 	require("sandr").search_and_replace({ visual = true })
-- end, {})
vim.keymap.set("c", "<C-x>", function()
	local cmdline = vim.fn.getcmdline()
	local cmd = string.rep("<BS>", #cmdline)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "i", true)
end, { noremap = true })

vim.api.nvim_set_keymap("c", "<C-f>", "/<Up>", { noremap = true })

-- Better window navigation
vim.keymap.set("n", "<C-Up>", "<C-w>k", opts)
vim.keymap.set("n", "<C-Down>", "<C-w>j", opts)
vim.keymap.set("n", "<C-Left>", "<C-w>h", opts)
vim.keymap.set("n", "<C-Right>", "<C-w>l", opts)

-- Resize with arrows
vim.keymap.set("n", "<C-A-Up>", ":resize -10<CR>", opts)
vim.keymap.set("n", "<C-A-Down>", ":resize +10<CR>", opts)
vim.keymap.set("n", "<C-A-Left>", ":vertical resize -10<CR>", opts)
vim.keymap.set("n", "<C-A-Right>", ":vertical resize +10<CR>", opts)

-- Navigate buffers
vim.keymap.set("n", "<S-Right>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Left>", ":bprevious<CR>", opts)
vim.keymap.set("n", "gb", "<C-o>", opts)
vim.keymap.set("n", "db", "vdb", opts)
vim.keymap.set("n", "cb", "vcb", opts)
-- Better paste
vim.keymap.set("v", "p", '"_dP', opts)

-- Insert --
-- Press jk fast to enter
-- keymap("i", "ne", "<ESC>")

-- Visual --
-- Stay in indent mode
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

vim.keymap.set("n", "<leader><leader>ff", "<cmd>lua MiniPick.builtin.files()<cr>", opts)
vim.keymap.set("n", "<leader><leader>c", "<cmd>Col<cr>", opts)
vim.keymap.set("n", "<leader><leader>y", ":lua", opts)
vim.keymap.set("n", "<F5>", "<cmd>lua require('osv').launch({port=8086})<cr>", opts)

vim.keymap.set("n", "<S-CR>", "lua print('') print('shift enter pressed')", opts)
