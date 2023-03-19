return {
  { "phaazon/hop.nvim", branch = "v2", commit = "2a1b686aad85a3c241f8cd8fd42eb09c7de5ed79" },
  { "nvim-lua/plenary.nvim", commit = "4b7e52044bbb84242158d977a50c4cbcd85070c7" },
  { "ahmedkhalf/project.nvim", commit = "628de7e433dd503e782831fe150bb750e56e55d6" },
  { "lukas-reineke/indent-blankline.nvim", commit = "db7cbcb40cc00fc5d6074d7569fb37197705e7f6" },
  {
    "GustavoKatel/tasks.nvim",
    commit = "1bb8b9725cc7bb58e646d9a8da48a57010cafcad",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "elianiva/telescope-npm.nvim"
    },
    config = function()
      require("telescope").load_extension("tasks")
      local tasks = require("tasks")
      local source_npm = require("tasks.sources.npm")
      local source_tasksjson = require("tasks.sources.tasksjson")

      local builtin = require("tasks.sources.builtin")

      tasks.setup({
        sources = {
          npm = source_npm,
          vscode = source_tasksjson,
          utils = builtin.new_builtin_source({
            npm_install = {
              cmd = "npm install"
            },
            tsc_watch = {
              cmd = "tsc -w"
            },
          }),
        },
      })
    end
  },
  {
    "https://git.sr.ht/~nedia/auto-save.nvim",
    event = "BufWinEnter",
    config = function()
      require "user.autosave"
    end
  },
  { "Susensio/magic-bang.nvim" },
  { "nvim-pack/nvim-spectre", dependencies = { "nvim-lua/plenary.nvim" } },
  { 'echasnovski/mini.pairs', version = '*' },
  {
    'echasnovski/mini.surround',
    version = '*',
    event = "BufWinEnter",
    config = function()
      require("user.surround")
    end
  },
  {
    'echasnovski/mini.bufremove',
    version = '*',
    event = "BufWinEnter",
    config = function()
      require('mini.bufremove').setup()
    end
  },
  {
    dir = '~/Projects/haxe-nvim',
    event = "BufWinEnter",
    config = function()
      require "haxe-nvim"
    end
  }
}
