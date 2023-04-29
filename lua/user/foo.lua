local nui = require('nui')

-- Create the template buffer
local template_bufnr = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(template_bufnr, 0, -1, false, {'Template buffer'})

-- Create the typing buffer
local typing_bufnr = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(typing_bufnr, 0, -1, false, {'Typing buffer'})

-- Create the popup for progress and numbers
local popup = nui.Popup({
  enter = true,
  focusable = true,
  border = {
    style = 'rounded',
  },
  position = '50%',
  size = {
    width = '80%',
    height = '40%',
  },
}, {

  nui.Buffer({
    bufnr = vim.api.nvim_create_buf(false, true),
    relative = 'editor',
    width = 1,
    height = 1,
    row = 0,
    col = 0,
  }),
})

-- Create the split layout
local split = nui.object({
  _type = "nui.split",
  relative = 'editor',
  width = 1,
  height = 0.5,
  row = 0,
  col = 0,
  children = {
    nui.object({
      _type = "nui.buffer",
      bufnr = template_bufnr,
      relative = 'editor',
      width = 1,
      height = 1,
      row = 0,
      col = 0,
    }),
    nui.object({
      _type = "nui.buffer",
      bufnr = typing_bufnr,
      relative = 'editor',
      width = 1,
      height = 1,
      row = 0,
      col = 0,
    }),
    popup,
  },
})

-- Mount the components
split:mount()

-- Unmount the components when the cursor leaves the buffer
popup:on(nui.autocmd.event.BufLeave, function()
  popup:unmount()
end)

