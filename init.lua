local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require "user.options"
require "user.keymaps"
require "user.lazy"
require "user.autocommands"
require "user.colorscheme"
require "user.cmp"
require "user.telescope"
require "user.treesitter"
require "user.autopairs"
require "user.comment"
require "user.gitsigns"
require "user.nvim-tree"
require "user.lualine"
require "user.toggleterm"
require "user.project"
require "user.impatient"
require "user.illuminate"
require "user.indentline"
require "user.alpha"
require "user.lsp"
require "user.dap"
require "user.whichkey"
require "user.mason"
require "user.git-blame"
require "user.searchbox"
require "user.hop"
require "user.surround"
require "user.noice"
require "user.autosave"
require "user.dial"
require "user.dirbuf"
require "user.yanky"
require "user.bufferline"
require "user.no-neck-pain"
require "user.magic-bang"
require "user.spectre"
require "user.reticle"
