return {
  event="BufWinEnter",
  "onsails/lspkind.nvim",
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  config = function()
    local lspkind = require('lspkind')
    local lspkind_opts = {
      mode = "symbol",
      symbol_map = {
        Array = "",
        Boolean = "⊨",
        Class = "",
        Constructor = "",
        Key = "",
        Namespace = "",
        Null = "NULL",
        Number = "#",
        Object = "",
        Package = "",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "",
        TypeParameter = "",
        Unit = "",
      },
    }
    lspkind.init(lspkind_opts)
  end
}
