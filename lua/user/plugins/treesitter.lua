return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("user.treesitter")
    end
  },
  {
    "nvim-treesitter/playground",
    commit = "1290fdf6f2f0189eb3b4ce8073d3fda6a3658376",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    event = "BufWinEnter",
    url = "https://gitlab.com/HiPhish/nvim-ts-rainbow2",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "windwp/nvim-ts-autotag",
    commit = "5bbdfdaa303c698f060035f37a91eaad8d2f8e27",
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    commit = "4d3a68c41a53add8804f471fcc49bb398fe8de08",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    'Wansmer/treesj',
    keys = { '<space>m', '<space>j', '<space>s' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({ max_join_length = 999, })
    end,
  }
}
