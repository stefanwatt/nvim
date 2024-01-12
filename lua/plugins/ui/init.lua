return {
  require("plugins.ui.catppuccin"),
  {
    "nvim-tree/nvim-web-devicons",
    config=function ()
      require'nvim-web-devicons'.setup({})
    end
  }
}
