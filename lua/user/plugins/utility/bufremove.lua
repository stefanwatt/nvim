return {
  'echasnovski/mini.bufremove',
  version = '*',
  event = "VeryLazy",
  config = function()
    require('mini.bufremove').setup()
  end
}
