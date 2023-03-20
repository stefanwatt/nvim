-- Use 'q' to quit from common plugins
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir" },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]]
  end,
})

-- Remove statusline and tabline when in Alpha
-- vim.api.nvim_create_autocmd({ "User" }, {
--   pattern = { "AlphaReady" },
--   callback = function()
--     vim.cmd [[
--       set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
--       set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
--     ]]
--   end,
-- })

-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"

-- Fixes Autocomment
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.cmd "set formatoptions-=cro"
  end,
})

-- Highlight Yanked Text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
  end,
})


require("auto-save").setup({
  -- The name of the augroup.
  augroup_name = "AutoSavePlug",
  -- The events in which to trigger an auto save.
  events = { "InsertLeave", "TextChanged" },
  -- If you'd prefer to silence the output of `save_fn`.
  silent = true,
  -- If you'd prefer to write a vim command.
  save_cmd = nil,
  -- What to do after checking if auto save conditions have been met.
  save_fn = function()
    local config = require("auto-save.config")
    if config.save_cmd ~= nil then
      vim.cmd(config.save_cmd)
    else
      vim.cmd("w")
    end
    print("autosaved")
  end,
  -- May define a timeout, or a duration to defer the save for - this allows
  -- for formatters to run, for example if they're configured via an autocmd
  -- that listens for `BufWritePre` event.
  timeout = nil,
  -- Define some filetypes to explicitly not save, in case our existing conditions
  -- don't quite catch all the buffers we'd prefer not to write to.
  exclude_ft = { "" },
})
