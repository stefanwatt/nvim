return {
  {
    event = "BufWinEnter",
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require('null-ls')
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
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  filter = function(client)
                    return client.name == "null-ls"
                  end
                })
              end,
            })
          end
        end,
      }
    end
  }
}
