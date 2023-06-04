return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        pyright = {},
        angularls={},
        astro={},
        bashls={},
        cssls={},
        eslint={},
        emmet_ls={},
        html={},
        jsonls={},
        lua_ls={},
        marksman={},
        sqlls={},
        svelte={},
        tailwindcss={},
        -- 'tsserver',
        vimls={},
        lemminx={},
        yamlls={},
        rust_analyzer={},
      },
    },
  },
}
