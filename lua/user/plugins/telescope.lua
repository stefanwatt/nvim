return {
  { "nvim-telescope/telescope.nvim"},

  { "elianiva/telescope-npm.nvim", commit = "60eee38b34f577104475a592dd3716a7afa2aef1" },
  { "ibhagwan/fzf-lua",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    commit = "e7c610889ff954101c644cdb9cf68e499a3751ac"
  },
  { "tami5/sqlite.lua", commit = "47685f0adb89928fc1b2a9b812418680f29aaf27" },
  { "nvim-telescope/telescope-frecency.nvim",
    dependencies = { "tami5/sqlite.lua" },
    commit = "9634c3508c6565284065ec011476204ce13f354a"
  },
  { "danielvolchek/tailiscope.nvim" },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  { 'molecule-man/telescope-menufacture' }
}
