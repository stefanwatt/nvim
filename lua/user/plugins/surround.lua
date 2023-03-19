return {
  'echasnovski/mini.surround',
  version = '*',
  event = "BufWinEnter",
  config = function()
    require("user.surround")
  end
}
