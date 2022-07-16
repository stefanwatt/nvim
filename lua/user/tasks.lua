local tasks = require("tasks")

local source_npm = require("tasks.sources.npm")
local source_tasksjson = require("tasks.sources.tasksjson")

local builtin = require("tasks.sources.builtin")

require("telescope").load_extension("tasks")

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
