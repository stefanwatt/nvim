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
  { "nvim-lualine/lualine.nvim", commit = "a52f078026b27694d2290e34efa61a6e4a690621" },
  { "kyazdani42/nvim-tree.lua", commit = "7282f7de8aedf861fe0162a559fc2b214383c51c" },
  { "goolord/alpha-nvim", commit = "0bb6fc0646bcd1cdb4639737a1cee8d6e08bcc31" },
  { "akinsho/toggleterm.nvim", commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda" },
  {
    "akinsho/bufferline.nvim",
    tag = "v3.0.0",
    commit = "a40f058c6284855ad6a8b8137b3e312beca4d6aa",
    dependencies = {"nvim-tree/nvim-web-devicons"}
  },
  { "elihunter173/dirbuf.nvim", commit = "ac7ad3c8e61630d15af1f6266441984f54f54fd2" },
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
}
