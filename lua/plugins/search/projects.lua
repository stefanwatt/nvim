return {
  {
    event = "VeryLazy",
    "ahmedkhalf/project.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern" },
        patterns = { ".git", "Makefile", "package.json" },
      })
    end
  }
}
