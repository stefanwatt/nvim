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
}

telescope.load_extension("tasks")
telescope.load_extension("frecency")


local tasks = require("tasks")

local source_npm = require("tasks.sources.npm")
local source_tasksjson = require("tasks.sources.tasksjson")

local builtin = require("tasks.sources.builtin")

tasks.setup({
	sources = {
		npm = source_npm,
		vscode = source_tasksjson,
		utils = builtin.new_builtin_source({
      npm_install= {
          cmd = "npm install"
      },
      tsc_watch= {
          cmd = "tsc -w"
      },
		}),
	},
})

require('telescope').load_extension('tailiscope')
