return {
  {
    "nvim-treesitter/playground",
    commit = "1290fdf6f2f0189eb3b4ce8073d3fda6a3658376",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    event = "VeryLazy",
    url = "https://gitlab.com/HiPhish/nvim-ts-rainbow2",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    commit = "5bbdfdaa303c698f060035f37a91eaad8d2f8e27",
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "VeryLazy",
    commit = "4d3a68c41a53add8804f471fcc49bb398fe8de08",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  require("user.plugins.treesitter.splitjoin"),
  require("user.plugins.treesitter.misc"),
}
