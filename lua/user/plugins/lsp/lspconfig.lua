return {
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'williamboman/mason.nvim' },
    },
    config = function()
      local lsp = require('lsp-zero')

      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
      end)

      local servers = {
        'angularls',
        'astro',
        'bashls',
        'cssls',
        'denols',
        'eslint',
        'emmet_ls',
        'html',
        'jsonls',
        'lua_ls',
        'marksman',
        'pyright',
        'sqlls',
        'svelte',
        'tailwindcss',
        'vtsls',
        'lemminx',
        'yamlls',
        'rust_analyzer',

      }

      lsp.ensure_installed(servers)

      lsp.setup_servers(servers)

      lsp.set_server_config({
        single_file_support = false,
        capabilities = {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true
            }
          }
        }
      })

      require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
      lsp.setup()
    end
  }
}
