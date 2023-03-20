return {
  {
    "elianiva/telescope-npm.nvim",
    cmd="Telescope",
    commit = "60eee38b34f577104475a592dd3716a7afa2aef1",
    config = function()
      require("tasks.sources.npm")
    end
  }
}
