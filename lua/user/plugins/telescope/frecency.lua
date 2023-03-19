return {
  { "nvim-telescope/telescope-frecency.nvim",
    dependencies = { "tami5/sqlite.lua" },
    commit = "9634c3508c6565284065ec011476204ce13f354a",
    config = function()
      require("telescope").load_extension("frecency")
    end
  }
}
