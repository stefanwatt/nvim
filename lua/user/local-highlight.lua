local lhl = require('local-highlight')
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.*' },
  callback = function(data)
    lhl.attach(data.buf)
  end
})
lhl.setup({
  file_types = { 'lua' }
})
