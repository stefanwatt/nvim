require('image').setup {
  render = {
    min_padding = 5,
    show_label = true,
    use_dither = true,
    foreground_color = false,
    background_color = false
  },
  events = {
    update_on_nvim_resize = true,
  },
}

vim.cmd([[
  let s:baleia = luaeval("require('baleia').setup { }")
  command! BaleiaColorize call s:baleia.once(bufnr('%'))
]])
