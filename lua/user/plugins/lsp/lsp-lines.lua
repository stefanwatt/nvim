return {
  {
    "stefanwatt/lsp-lines.nvim",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({
        virtual_text = false,
      })
      vim.diagnostic.config({ virtual_lines = false })
    end
  }
}
