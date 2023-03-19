return {
  {
    "nvim-telescope/telescope.nvim",
    config=function ()
      require("user.telescope")
    end
  },
  { 
    "elianiva/telescope-npm.nvim", commit = "60eee38b34f577104475a592dd3716a7afa2aef1",
    config = function ()
      require("tasks.sources.npm")
    end
  },
  { "ibhagwan/fzf-lua",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    commit = "e7c610889ff954101c644cdb9cf68e499a3751ac"
  },
  { "tami5/sqlite.lua", commit = "47685f0adb89928fc1b2a9b812418680f29aaf27" },
  { "nvim-telescope/telescope-frecency.nvim",
    dependencies = { "tami5/sqlite.lua" },
    commit = "9634c3508c6565284065ec011476204ce13f354a",
    config = function()
      require("telescope").load_extension("frecency")
    end
  },
  {
    "danielvolchek/tailiscope.nvim",
    config = function()
      require('telescope').load_extension "tailiscope"
    end
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require('telescope').load_extension "file_browser"
    end
  },
  {
    'molecule-man/telescope-menufacture',
    config = function()
      require('telescope').load_extension "menufacture"
    end
  }
}
