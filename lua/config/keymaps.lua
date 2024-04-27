-- Silent keymap option
local opts = { silent = true }

vim.keymap.set("n", "<leader>T", function()
	local cwd = vim.fn.getcwd()
	os.execute(
		'i3-msg \'split v;exec wezterm start --class "term-bottom" --cwd '
			.. cwd
			.. ";' && sleep 0.2 && i3-msg 'resize set height 400'"
	)
end, opts)
-- Normal --
vim.keymap.set("n", "<BS>", "ciw", opts)
vim.keymap.set("n", "<CR>", function()
	local buftype = vim.api.nvim_buf_get_option(0, "buftype")
	if buftype == "quickfix" then
		return
	end
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_input("ggVGy")
	vim.schedule(function()
		vim.api.nvim_win_set_cursor(0, cursor_pos)
	end)
end, opts)
vim.keymap.set({ "n", "i", "v", "x" }, "<C-p>", ":cprev<CR>", opts)
vim.keymap.set({ "n", "i", "v", "x" }, "<C-n>", ":cnext<CR>", opts)
vim.keymap.set("n", "<leader>q", ":q!<CR>", opts)
vim.keymap.set("n", "<leader>w", ":w!<CR>", opts)
vim.keymap.set("n", "<C-s>", ":wall<CR>", opts)
vim.keymap.set("n", "<C-x>", require("config.utils").MoveBufferToOppositeWindow, opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
vim.keymap.set("v", ":", function()
	vim.cmd('normal! "vy')
	local text = vim.fn.getreg("v")
	vim.api.nvim_input(":<C-u>" .. text)
end, { noremap = true, silent = true, desc = "Open cmdline with visual selection" })

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
vim.keymap.set("n", "db", "vbd", opts)
vim.keymap.set("n", "cb", "vbc", opts)
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
-- vim.keymap.set("n", "<leader><leader>c", "<cmd>Col<cr>", opts)
vim.keymap.set("n", "<leader><leader>y", ":lua", opts)
vim.keymap.set("n", "<F5>", "<cmd>lua require('osv').launch({port=8086})<cr>", opts)

vim.keymap.set("n", "<S-CR>", "lua print('') print('shift enter pressed')", opts)
