return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    commit = "c0c19f32b614b3921e17886c541c13a72748d450",
    config = function()
      local null_ls_status_ok, null_ls = pcall(require, "null-ls")
      if not null_ls_status_ok then
        return
      end
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics

      null_ls.setup {
        debug = false,
        sources = {
          formatting.prettier.with {
            extra_filetypes = { "tsserver", "typescript", "ts", "toml", "solidity", "svelte", "astro" },
            extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
          },
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            -- vim.api.nvim_create_autocmd("BufLeave", {
            --   group = augroup,
            --   buffer = bufnr,
            --   callback = function()
            --     vim.lsp.buf.format()
            --   end,
            -- })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end
        end,
      }
    end
  }
}
