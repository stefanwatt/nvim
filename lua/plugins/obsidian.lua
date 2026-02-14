return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "work",
        path = "~/Documents/",
      },
    },
    daily_notes = {
      folder = "daily-notes",
      date_format = "%Y/%m-%B/%d-%m-%Y"
    }
  },
}
