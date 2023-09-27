return {
  {
    'Wansmer/treesj',
    event="VeryLazy",
    keys = { '<space>m', '<space>j', '<space>s' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({ max_join_length = 999, })
    end,
  }
}
