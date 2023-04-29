return {
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'williamboman/mason.nvim' },
      { 'yioneko/nvim-vtsls'}
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
        'lemminx',
        'yamlls',
        'rust_analyzer',
      }

      lsp.ensure_installed(servers)

      table.insert(servers, 'vtsls')
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

      local lspconfig = require('lspconfig')
      lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
      require("lspconfig.configs").vtsls = require("vtsls").lspconfig -- set default server config
      lspconfig.vtsls.setup({ --[[ your custom server config here ]] })
      lsp.setup()
    end
  }
}
