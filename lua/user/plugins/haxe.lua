return {
  dir = '~/Projects/haxe-nvim',
  event = "BufWinEnter",
  config = function()
    require "haxe-nvim"
  end
}
