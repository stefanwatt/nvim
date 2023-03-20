return {
  'echasnovski/mini.bufremove',
  version = '*',
  event = "BufWinEnter",
  config = function()
    require('mini.bufremove').setup()
  end
}
