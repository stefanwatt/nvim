return {
  { "MunifTanjim/nui.nvim" },
  {
    "stefanwatt/noice.nvim",
    event = "VimEnter",

    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "hrsh7th/nvim-cmp",
    }

  },
  { "kyazdani42/nvim-web-devicons", commit = "563f3635c2d8a7be7933b9e547f7c178ba0d4352" },
  { "goolord/alpha-nvim", commit = "0bb6fc0646bcd1cdb4639737a1cee8d6e08bcc31" },
  { "akinsho/toggleterm.nvim", commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda" },
  {
    "akinsho/bufferline.nvim",
    tag = "v3.0.0",
    commit = "a40f058c6284855ad6a8b8137b3e312beca4d6aa",
    dependencies = { "kyazdani42/nvim-web-devicons" }
  },
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
    "shortcuts/no-neck-pain.nvim",
    -- pin=true,
  },
  { "Tummetott/reticle.nvim" },
  { "tzachar/local-highlight.nvim" },
  {
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
  },
}
