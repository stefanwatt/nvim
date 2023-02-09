return {
  { "williamboman/mason.nvim", commit = "6f706712ec0363421e0988cd48f512b6a6cf7d6e" },
  {
    'VonHeikemen/lsp-zero.nvim',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  },

  { "jose-elias-alvarez/null-ls.nvim", commit = "c0c19f32b614b3921e17886c541c13a72748d450" },
  {
    'glepnir/lspsaga.nvim',
    commit="b7b4777369b441341b2dcd45c738ea4167c11c9e",
    event = 'BufRead',
  },
  { "stefanwatt/lsp-lines.nvim" },
  { "mfussenegger/nvim-jdtls", commit = "75d27daa061458dd5735b5eb5bbc48d3baad1186" }
}
