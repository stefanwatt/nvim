return {
  dir = '~/Projects/haxe-nvim',
  event = "BufEnter *.hx",
  config = function()
    require "haxe-nvim"
  end
}
