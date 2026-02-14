return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  config = function()
    local amount = 10
    local smart_splits = require('smart-splits')
    vim.keymap.set('n', '<A-Left>', require('smart-splits').resize_left)
    vim.keymap.set('n', '<A-Down>', require('smart-splits').resize_down)
    vim.keymap.set('n', '<A-Up>', require('smart-splits').resize_up)
    vim.keymap.set('n', '<A-Right>', require('smart-splits').resize_right)
    -- moving between splits
    vim.keymap.set('n', '<C-Left>', require('smart-splits').move_cursor_left)
    vim.keymap.set('n', '<C-Down>', require('smart-splits').move_cursor_down)
    vim.keymap.set('n', '<C-Up>', require('smart-splits').move_cursor_up)
    vim.keymap.set('n', '<C-Right>', require('smart-splits').move_cursor_right)
    -- swapping buffers between windows
    vim.keymap.set('n', '<leader><leader><Left>', require('smart-splits').swap_buf_left)
    vim.keymap.set('n', '<leader><leader><Down>', require('smart-splits').swap_buf_down)
    vim.keymap.set('n', '<leader><leader><Up>', require('smart-splits').swap_buf_up)
    vim.keymap.set('n', '<leader><leader><Right>', require('smart-splits').swap_buf_right)
  end
}
