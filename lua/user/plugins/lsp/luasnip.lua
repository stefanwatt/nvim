return {
  {
    'L3MON4D3/LuaSnip',
    version = "1.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    build = "make install_jsregexp",
    dependencies = {
      { 'rafamadriz/friendly-snippets' },
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  }
}
