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
      keymap("n", "gD", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
      keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { silent = true })
      keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")
   end
  },
}
