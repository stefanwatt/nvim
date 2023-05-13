return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    lazy = false,
    dependencies = {
      { 'neovim/nvim-lspconfig' }, -- Required
      {
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional
      { 'hrsh7th/nvim-cmp' },     -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'L3MON4D3/LuaSnip' },     -- Required
      { 'yioneko/nvim-vtsls'}
    },
    config = function()
      require("neodev").setup({})
      local lsp = require('lsp-zero').preset({})
      lsp.set_preferences({
        suggest_lsp_servers = true,
        setup_servers_on_start = true,
        set_lsp_keymaps = false,
        configure_diagnostics = true,
        cmp_capabilities = true,
        manage_nvim_cmp = true,
        call_servers = 'local',
      })

      lsp.set_sign_icons({
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»'
      })

      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
      end)

      local lspconfig = require('lspconfig')
      lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
      -- require("lspconfig.configs").vtsls = require("vtsls").lspconfig -- set default server config
      -- lspconfig.vtsls.setup({ --[[ your custom server config here ]] })
      lsp.setup()
    end
  },
  require("user.plugins.lsp.cmp"),
  require("user.plugins.lsp.null-ls"),
  require("user.plugins.lsp.lsp-saga"),
  require("user.plugins.lsp.lsp-lines"),
  require("user.plugins.lsp.lspkind"),
  require("user.plugins.lsp.misc"),
  require("user.plugins.lsp.luasnip"),
}
