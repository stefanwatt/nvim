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

for k, server in pairs(servers) do
  local capabilities = lsp_capabilities
  if (server == 'tsserver') then
    -- lspconfig[server].setup(tsserverConfig)
  else
    lspconfig[server].setup({
      on_attach = lsp_attach,
      capabilities = lsp_capabilities,
    })
  end
end

require("lspconfig.configs").vtsls = require("vtsls").lspconfig -- set default server config
require("lspconfig").vtsls.setup({ --[[ your custom server config here ]] })
