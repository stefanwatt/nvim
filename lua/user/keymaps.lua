-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
keymap("n", "<leader>q", ":q!<CR>", opts)
keymap("n", "<leader>w", ":w!<CR>", opts)
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
-- Better window navigation
keymap("n", "<C-Up>", "<C-w>k", opts)
keymap("n", "<C-Down>", "<C-w>j", opts)
keymap("n", "<C-Left>", "<C-w>h", opts)
keymap("n", "<C-Right>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-A-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-A-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-A-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-A-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-Right>", ":bnext<CR>", opts)
keymap("n", "<S-Left>", ":bprevious<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Insert --
-- Press jk fast to enter
-- keymap("i", "ne", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("n", "<leader>ts", ":TypingTest start<cr>", opts)
keymap("n", "<leader>tq", ":TypingTest stop<cr>", opts)

keymap("n", "s", ":HopChar1<CR>", opts)
keymap("n", "S", ":HopChar2<CR>", opts)
keymap("n", "l", ":HopLine<CR>", opts)
-- keymap("n", "f", ":HopChar2CurrentLine<CR>", opts)
-- keymap("n", "F", ":HopChar1CurrentLine<CR>", opts)

-- keymap("v", "f", "<cmd>HopChar2CurrentLine<CR>", opts)
keymap("v", "s", "<cmd>HopWord<CR>", opts)

keymap("n", "<leader><leader>x", "<cmd>so %<cr> :lua print('file reloaded')<cr>", opts)

keymap("n", "<F13>", "<cmd>lua print('f13')<cr>", opts)
keymap("n", "<F14>", "<cmd>lua print('f14')<cr>", opts)
keymap("n", "<F15>", "<cmd>lua print('f15')<cr>", opts)
keymap("n", "<F16>", "<cmd>lua print('f16')<cr>", opts)
