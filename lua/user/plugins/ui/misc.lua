return {
  { "MunifTanjim/nui.nvim" },
  { "kyazdani42/nvim-web-devicons" },
  {
    "VonHeikemen/searchbox.nvim",
    commit = "4b8d3bb68283d27434d81b92424f1398fa9d739a",
    dependencies = { "MunifTanjim/nui.nvim" }
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
    commit = "02cc3874738bc0f86e4b91f09b8a0ac88aef8e96"
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    -- optionally, override the default options:
    lazy = false,
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end
  }
}
