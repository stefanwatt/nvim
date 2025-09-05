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
vim.keymap.set("n", "<leader>q", ":q!<CR>", opts)
vim.keymap.set("n", "<leader>Q", ":qall<CR>", opts)
vim.keymap.set("n", "<leader>w", ":w!<CR>", opts)
vim.keymap.set("n", "<C-s>", ":wall<CR>", opts)
vim.keymap.set("n", "<C-x>", utils.MoveBufferToOppositeWindow, opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

vim.keymap.set("n", "<leader>gg", function()
  utils.exec("wezterm start --class foo --always-new-process --cwd " .. vim.uv.cwd() .. " -- lazygit")
end, opts)
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

vim.keymap.set("n", "<leader>r", ":%s///gi<Left><Left><Left><Left>", opts)

vim.keymap.set("v", "<leader>r", function()
  vim.cmd('normal! "vy')
  local text = vim.fn.getreg("v")
  vim.api.nvim_input(":%s/" .. text .. "//gi<Left><Left><Left>")
end, opts)

vim.keymap.set("n", "<leader>v", ":vsplit<CR>", opts)
vim.keymap.set("n", "<leader>V", function()
  utils.exec("wezterm cli split-pane --horizontal")
end, opts)
-- vim.keymap.set("n", "<leader>T", function()
--   utils.exec("wezterm cli split-pane --bottom --percent 30")
-- end, opts)


-- Navigate buffers
vim.keymap.set("n", "<S-Right>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Left>", ":bprevious<CR>", opts)
vim.keymap.set("n", "gb", "<C-o>", opts)
vim.keymap.set("n", "gf", "<C-i>", opts)
vim.keymap.set("n", "db", "vbd", opts)
vim.keymap.set("n", "cb", "vbc", opts)
-- Better paste
vim.keymap.set("v", "p", '"_dP', opts)

-- Swap current line with the line above
vim.keymap.set("n", "<A-Up>", function()
  local current_line = vim.fn.line(".")
  if current_line > 1 then
    vim.cmd("move -2")
  end
end, opts)

-- Swap current line with the line below
vim.keymap.set("n", "<A-Down>", function()
  local current_line = vim.fn.line(".")
  local last_line = vim.fn.line("$")
  if current_line < last_line then
    vim.cmd("move +1")
  end
end, opts)     -- Stay in indent mode
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

vim.keymap.set("n", "<F5>", "<cmd>lua require('osv').launch({port=8086})<cr>", opts)

vim.keymap.set("n", "<S-CR>", "lua print('') print('shift enter pressed')", opts)

function RunNgTestForCurrentFile()
  local current_file = vim.fn.expand('%:p')
  local project_root = vim.fn.getcwd()
  local relative_path = string.gsub(current_file, project_root .. '/', '')
  local command = 'ng test drug-preparation-list --watch=false --include=' .. relative_path
  vim.cmd('!' .. command)
end

vim.keymap.set("n", "tr", RunNgTestForCurrentFile, opts)

vim.api.nvim_set_keymap('n', ']b', '<Plug>JumpDiffCharNextStart', { noremap = false })
vim.api.nvim_set_keymap('n', '[b', '<Plug>JumpDiffCharPrevStart', { noremap = false })
