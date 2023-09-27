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
keymap("n", "<BS>", "ciw", opts)
keymap("n", "<CR>", "viwP", opts)
keymap("n", "<leader>q", ":q!<CR>", opts)
keymap("n", "<leader>w", ":w!<CR>", opts)
keymap("n", "<leader>l", function() end, opts)
keymap("n", "<C-s>", ":wall<CR>")
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
-- Better window navigation
keymap("n", "<C-Up>", "<C-w>k", opts)
keymap("n", "<C-Down>", "<C-w>j", opts)
keymap("n", "<C-Left>", "<C-w>h", opts)
keymap("n", "<C-Right>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-A-Up>", ":resize -10<CR>", opts)
keymap("n", "<C-A-Down>", ":resize +10<CR>", opts)
keymap("n", "<C-A-Left>", ":vertical resize -10<CR>", opts)
keymap("n", "<C-A-Right>", ":vertical resize +10<CR>", opts)

-- Navigate buffers
keymap("n", "<S-Right>", ":bnext<CR>", opts)
keymap("n", "<S-Left>", ":bprevious<CR>", opts)

keymap("n", "gb", "<C-o>", opts)
-- Better paste
keymap("v", "p", '"_dP', opts)

-- Insert --
-- Press jk fast to enter
-- keymap("i", "ne", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("n", "<leader><leader>x", "<cmd>so %<cr> :lua print('file reloaded')<cr>", opts)

keymap("n", "s", function()
	require("flash").jump({
		search = {
			mode = function(str)
				return "\\<" .. str
			end,
		},
	})
end, { silent = true, noremap = true })

keymap("v", "<leader><leader>s", "<Esc><cmd>SvelteExtractToComponent<cr>", opts)
