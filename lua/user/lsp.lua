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
  'tsserver',
  'vimls',
  'lemminx',
  'yamlls',
  'rust_analyzer',
}

local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_attach = function(client, bufnr)
  -- Create your keybindings here...
end

local lspconfig = require('lspconfig')

for k, server in pairs(servers) do
  lspconfig[server].setup({
    on_attach = lsp_attach,
    capabilities = lsp_capabilities,
  })
end
