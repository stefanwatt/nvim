local decay = require('decay')

decay.setup({
  style = 'normal',
  nvim_tree = {
    contrast = true, -- or false to disable tree contrast
  },
  italics = {
    code = true,
    comments = true,
  }
})

local colorscheme = "decay"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end
