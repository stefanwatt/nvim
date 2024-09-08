return {
  "gbprod/substitute.nvim",
  lazy = false,
  keys = {
    {
      "s",
      mode = { "n" },
      function()
        require('substitute').operator()
      end,
      desc = "substitute"
    },
    { "ss", mode = { "n" }, function() require('substitute').line() end, desc = "substitute line" },
  },
  opts = {
    yank_substituted_text = false,
    preserve_cursor_position = true,
    highlight_substituted_text = {
      enabled = true,
      timer = 500,
    },
  }
}
