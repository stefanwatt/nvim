require('searchbox').setup({
  defaults = {
    reverse = false,
    exact = false,
    prompt = ' ',
    modifier = 'disabled',
    confirm = 'off',
    clear_matches = true,
    show_matches = false,
  },
  popup = {
    relative = 'win',
    position = {
      row = '5%',
      col = '95%',
    },
    size = 30,
    border = {
      style = 'rounded',
      text = {
        top = ' Search ',
        top_align = 'left',
      },
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
    },
  },
  hooks = {
    before_mount = function(input)
      -- code
    end,
    after_mount = function(input)
      local opts = { buffer = input.bufnr }
      vim.keymap.set('i', '<Up>', '<Plug>(searchbox-prev-match)', opts)
      vim.keymap.set('i', '<Down>', '<Plug>(searchbox-next-match)', opts)
      vim.keymap.set('i', '<Esc>', '<cmd>stopinsert<cr>', opts)
      vim.keymap.set('n', '<Esc>', '<Plug>(searchbox-close)', opts)
      vim.keymap.set('n', '<C-c>', '<Plug>(searchbox-close)', opts)
    end,
    on_done = function(value, search_type)
      -- code
    end
  }
})
