return {
  "folke/neodev.nvim",
  opts = {},
  config=function()
    require("neodev").setup({})
    local lsp_zero = require('lsp-zero')
    lsp_zero.extend_lspconfig()
    local lspconfig = require('lspconfig')
    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace"
          }
        }
      }
    })
  end
}
