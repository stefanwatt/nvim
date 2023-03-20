return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-file-browser.nvim",
    },
    lazy = "false",
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
          file_browser = {
            theme = "dropdown",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
              ["i"] = {
                -- your custom insert mode mappings
              },
              ["n"] = {
                -- your custom normal mode mappings
              },
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
