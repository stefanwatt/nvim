return {
  {
    event = "VeryLazy",
    'williamboman/mason.nvim',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'lukas-reineke/lsp-format.nvim' },
      { 'yioneko/nvim-vtsls' },
    },
  },
  require("user.plugins.lsp.cmp"),
  require("user.plugins.lsp.null-ls"),
  require("user.plugins.lsp.lsp-saga"),
  require("user.plugins.lsp.lsp-lines"),
  require("user.plugins.lsp.lspkind"),
  require("user.plugins.lsp.misc"),
  require("user.plugins.lsp.inlayhints"),
}
