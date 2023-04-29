return {
  {
    "stefanwatt/lsp-lines.nvim",
    event= "VeryLazy",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({
        virtual_text = false,
      })
      vim.diagnostic.config({ virtual_lines = false })
    end
  }
}
