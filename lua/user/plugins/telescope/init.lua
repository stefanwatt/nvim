return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-file-browser.nvim",
    },
    cmd = "Telescope",
    config = function()
      local actions = require "telescope.actions"
      require("telescope").setup {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
          file_ignore_patterns = { ".git/", "node_modules" },
          mappings = {
            i = {
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
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
