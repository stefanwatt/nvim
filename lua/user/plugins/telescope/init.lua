return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-file-browser.nvim",
    },
    cmd = "Telescope",
    config = function()
      local status_ok, telescope = pcall(require, "telescope")
      if not status_ok then
        return
      end

      local actions = require "telescope.actions"

      telescope.setup {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
          file_ignore_patterns = { ".git/", "node_modules" },
          mappings = {
            i = {
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
            },
          },
        },
        extensions = {
          menufacture = {
            mappings = {
              main_menu = { [{ 'n' }] = 'm' },
            },
          },
        },
      }
    end
  },
  require("user.plugins.telescope.file-browser"),
  require("user.plugins.telescope.menufacture"),
  require("user.plugins.telescope.frecency"),
  require("user.plugins.telescope.misc"),
  require("user.plugins.telescope.npm"),
  require("user.plugins.telescope.tailiscope"),
  require("user.plugins.telescope.projects"),
}
