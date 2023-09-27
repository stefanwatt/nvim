-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.o.timeoutlen = 500
vim.cmd([[
  if exists("g:neovide")
    set guifont=VictorMono\ Nerd\ Font:h12
    let g:neovide_refresh_rate=144
    let g:neovide_refresh_rate_idle=5
    let g:neovide_floating_blur_amount_x = 4.0
    let g:neovide_floating_blur_amount_y = 4.0
    let g:neovide_scroll_animation_length = 0.3
    let g:neovide_remember_window_size = v:false
    let g:neovide_cursor_vfx_mode = "pixiedust"
    let g:neovide_confirm_quit=v:false
    let g:neovide_cursor_vfx_particle_density = 200.0

  endif
]])

if vim.g.neovide then
  vim.g.neovide_input_use_logo = 1            -- enable use of the logo (cmd) key
  vim.keymap.set('n', '<D-s>', ':w<CR>')      -- Save
  vim.keymap.set('v', '<D-c>', '"+y')         -- Copy
  vim.keymap.set('n', '<D-v>', '"+P')         -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P')         -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+')      -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end
