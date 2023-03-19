return {
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("user.telescope")
    end
  },
  require("user.plugins.telescope.file-browser"),
  require("user.plugins.telescope.menufacture"),
  require("user.plugins.telescope.frecency"),
  require("user.plugins.telescope.misc"),
  require("user.plugins.telescope.npm"),
  require("user.plugins.telescope.tailiscope"),
}
