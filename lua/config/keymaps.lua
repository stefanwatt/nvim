-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
keymap("n", "<BS>", "ciw")
keymap("n", "<CR>", "ggVGy")
keymap("n", "<leader>q", ":q!<CR>")
keymap("n", "<leader>w", ":w!<CR>")
keymap("n", "<C-s>", ":wall<CR>")
keymap("n", "<C-x>", require("config.utils").MoveBufferToOppositeWindow)
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
-- Better window navigation
keymap("n", "<C-Up>", "<C-w>k")
keymap("n", "<C-Down>", "<C-w>j")
keymap("n", "<C-Left>", "<C-w>h")
keymap("n", "<C-Right>", "<C-w>l")

-- Resize with arrows
keymap("n", "<C-A-Up>", ":resize -10<CR>")
keymap("n", "<C-A-Down>", ":resize +10<CR>")
keymap("n", "<C-A-Left>", ":vertical resize -10<CR>")
keymap("n", "<C-A-Right>", ":vertical resize +10<CR>")

-- Navigate buffers
keymap("n", "<S-Right>", ":bnext<CR>")
keymap("n", "<S-Left>", ":bprevious<CR>")

keymap("n", "gb", "<C-o>")
-- Better paste
keymap("v", "p", '"_dP')

-- Insert --
-- Press jk fast to enter
-- keymap("i", "ne", "<ESC>")

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

keymap("n", "<leader><leader>x", "<cmd>so %<cr> :lua print('file reloaded')<cr>")

keymap("n", "s", function()
	require("flash").jump({
		search = {
			mode = function(str)
				return "\\<" .. str
			end,
		},
	})
end, { silent = true, noremap = true })

keymap("n", "<leader><leader>ff", "<cmd>lua MiniPick.builtin.files()<cr>")
keymap("n", "<leader><leader>c", "<cmd>Col<cr>")
keymap("n", "<F5>", "<cmd>lua require('osv').launch({port=8086})<cr>")
