require("lazy").setup("user.plugins", {
  defaults = { lazy = true },
  dev = {
    -- directory where you store your local plugin projects
    path = "~/Projects",
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = {"*.nvim"}, -- For example {"folke"}
  },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  debug = true,
})
