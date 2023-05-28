return {
  {
    'glepnir/lspsaga.nvim',
    event = 'LspAttach',
    dependencies = {
      { "kyazdani42/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" }
    },
    config = function()
      require("lspsaga").setup({})
      local keymap = vim.keymap.set
      local opts = { silent = true }
      keymap("n", "gD", "<cmd>Lspsaga peek_definition<CR>", opts)
      keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
      keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
    end
  },
}
