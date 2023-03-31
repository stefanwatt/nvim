return {
  { "nvim-lua/plenary.nvim", commit = "4b7e52044bbb84242158d977a50c4cbcd85070c7" },
  { "folke/neodev.nvim" },
  {
    dir="~/Projects/typing-test-lua",
    dev = true,
    event = "VeryLazy",
    config = function ()
      require("typing-test-lua").setup()
    end
  }
}
