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
keymap("n", "<leader>c", "<cmd>Bdelete<CR>", opts)
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

-- Close buffers
keymap("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "ne", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Comment
keymap("n", "<leader>/", "gcc", opts)
keymap("x", "<leader>/", 'gc', opts)

keymap("n", "<leader>ts", ":TypingTestStart<cr>", opts)
keymap("n", "<leader>tq", ":TypingTestQuit<cr>", opts)

keymap("n", "<C-f>", ":SearchBoxIncSearch show_matches=true<cr>", opts)
keymap("n", "<C-h>", ":SearchBoxReplace show_matches=true<cr>", opts)
keymap("x", "<C-f>", 'y<ESC>:SearchBoxIncSearch show_matches=true -- <C-r>" <CR>', opts)
keymap("x", "<C-h>", 'y<ESC>:SearchBoxReplace show_matches=true -- <C-r>" <CR>', opts)
keymap("x", "<C-A-f>", ':SearchBoxIncSearch show_matches=true <CR>', opts)
keymap("x", "<C-A-h>", ':SearchBoxReplace show_matches=true <CR>', opts)

keymap("n", "s", ":HopWord<CR>", opts)
keymap("n", "S", ":HopChar2<CR>", opts)
keymap("n", "l", ":HopLine<CR>", opts)
keymap("n", "f", ":HopChar2CurrentLine<CR>", opts)
keymap("n", "F", ":HopChar1CurrentLine<CR>", opts)

keymap("v", "f", "<cmd>HopChar2CurrentLine<CR>", opts)
keymap("v", "s", "<cmd>HopWord<CR>", opts)

keymap({"n","x"}, "p", "<Plug>(YankyPutAfter)",opts)
keymap({"n","x"}, "P", "<Plug>(YankyPutBefore)",opts)
keymap({"n","x"}, "gp", "<Plug>(YankyGPutAfter)",opts)
keymap({"n","x"}, "gP", "<Plug>(YankyGPutBefore)",opts)
keymap("n", "<c-n>", "<Plug>(YankyCycleForward)",opts)
keymap("n", "<c-p>", "<Plug>(YankyCycleBackward)",opts)

