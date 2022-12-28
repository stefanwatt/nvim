require("lazy").setup("user.plugins", {
  defaults = { lazy = true },
  dev = { patterns = jit.os:find("Windows") and {} or { "folke" } },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true },
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
