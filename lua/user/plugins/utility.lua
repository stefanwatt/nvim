return {
  { "phaazon/hop.nvim", branch = "v2", commit = "2a1b686aad85a3c241f8cd8fd42eb09c7de5ed79" },
  { "nvim-lua/plenary.nvim", commit = "4b7e52044bbb84242158d977a50c4cbcd85070c7" },
  { "ahmedkhalf/project.nvim", commit = "628de7e433dd503e782831fe150bb750e56e55d6" },
  { "lukas-reineke/indent-blankline.nvim", commit = "db7cbcb40cc00fc5d6074d7569fb37197705e7f6" },
  {
    "https://git.sr.ht/~nedia/auto-save.nvim",
    event = "BufWinEnter",
    config = function()
      require "user.autosave"
    end
  },
  { "Susensio/magic-bang.nvim" },
  { "nvim-pack/nvim-spectre", dependencies = { "nvim-lua/plenary.nvim" } },
}
