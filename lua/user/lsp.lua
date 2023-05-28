require("neodev").setup({})
require('mason').setup()
local servers = {
  'angularls',
  'astro',
  'bashls',
  'cssls',
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
  -- 'tsserver',
  'vimls',
  'lemminx',
  'yamlls',
  'rust_analyzer',
}

require("lsp-format").setup {}
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_attach = function(client, bufnr)
  if client.name == 'emmet_ls' then
    client.server_capabilities.completionProvider.triggerCharacters = { ".", "#" }
  end
  require("lsp-format").on_attach(client)
end

local lspconfig = require('lspconfig')

local tsserverConfig = {
  on_attach = lsp_attach,
  capabilities = lsp_capabilities,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }
    }
  }
}

local luaLSConfig = {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

for k, server in pairs(servers) do
  local capabilities = lsp_capabilities
  if (server == 'tsserver') then
    -- lspconfig[server].setup(tsserverConfig)
  elseif (server == 'lua_ls') then
    lspconfig[server].setup(luaLSConfig)
  else
    lspconfig[server].setup({
      on_attach = lsp_attach,
      capabilities = lsp_capabilities,
    })
  end
end

require("lspconfig.configs").vtsls = require("vtsls").lspconfig -- set default server config
require("lspconfig").vtsls.setup({ --[[ your custom server config here ]] })
