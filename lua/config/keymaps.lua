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
vim.keymap.set({ "n", "i", "v", "x" }, "<C-p>", ":cprev<CR>", opts)
vim.keymap.set({ "n", "i", "v", "x" }, "<C-n>", ":cnext<CR>", opts)
vim.keymap.set("n", "<leader>q", ":q!<CR>", opts)
vim.keymap.set("n", "<leader>Q", ":qall<CR>", opts)
vim.keymap.set("n", "<leader>w", ":w!<CR>", opts)
vim.keymap.set("n", "<C-s>", ":wall<CR>", opts)
vim.keymap.set("n", "<C-x>", utils.MoveBufferToOppositeWindow, opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

vim.keymap.set("n", "<leader>gg", function()
  utils.exec("wezterm start --class foo --always-new-process --cwd ".. vim.uv.cwd() .." -- lazygit")
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

vim.keymap.set("n", "<leader>r", ":%s///gci<Left><Left><Left><Left><Left>", opts)

vim.keymap.set("v", "<leader>r", function()
  vim.cmd('normal! "vy')
  local text = vim.fn.getreg("v")
  vim.api.nvim_input(":%s/" .. text.."//gci<Left><Left><Left><Left>")
end, opts)

vim.keymap.set("n", "<leader>v", ":vsplit<CR>", opts)
vim.keymap.set("n", "<leader>V", function()
  utils.exec("wezterm cli split-pane --horizontal")
end, opts)
vim.keymap.set("n", "<leader>T", function()
  utils.exec("wezterm cli split-pane --bottom --percent 30")
end, opts)


-- Navigate buffers
vim.keymap.set("n", "<S-Right>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Left>", ":bprevious<CR>", opts)
vim.keymap.set("n", "gb", "<C-o>", opts)
vim.keymap.set("n", "gf", "<C-i>", opts)
vim.keymap.set("n", "db", "vbd", opts)
vim.keymap.set("n", "cb", "vbc", opts)
-- Better paste
vim.keymap.set("v", "p", '"_dP', opts)

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

vim.keymap.set("n", "<F5>", "<cmd>lua require('osv').launch({port=8086})<cr>", opts)

vim.keymap.set("n", "<S-CR>", "lua print('') print('shift enter pressed')", opts)

function RunNgTestForCurrentFile()
  local current_file = vim.fn.expand('%:p')
  local project_root = vim.fn.getcwd()
  local relative_path = string.gsub(current_file, project_root .. '/', '')
  local command = 'ng test drug-preparation-list --watch=false --include=' .. relative_path
  vim.cmd('!' .. command)
end


vim.keymap.set("n", "tr",RunNgTestForCurrentFile, opts)
