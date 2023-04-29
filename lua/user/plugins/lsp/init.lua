return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    lazy = false,
    config = function()
      require("neodev").setup({})
      require('lsp-zero.settings').preset({})
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
      lsp.setup()
    end
  },
  require("user.plugins.lsp.cmp"),
  require("user.plugins.lsp.lspconfig"),
  require("user.plugins.lsp.null-ls"),
  require("user.plugins.lsp.lsp-saga"),
  require("user.plugins.lsp.lsp-lines"),
  require("user.plugins.lsp.lspkind"),
  require("user.plugins.lsp.misc"),
  require("user.plugins.lsp.luasnip"),
}
