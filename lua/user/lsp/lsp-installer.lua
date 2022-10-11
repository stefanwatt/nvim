local util = require 'vim.lsp.util'
local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

local servers = {
  "emmet_ls",
  "angularls",
  "svelte",
  "denols",
  "sumneko_lua",
  "cssls",
  "html",
  "tsserver",
  "pyright",
  "bashls",
  "jsonls",
  "yamlls",
  "jdtls",
  "tailwindcss",
  "rust_analyzer",
  "taplo"
}

lsp_installer.setup()

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }

  if server == "denols" then
    local deno_opts = {root_dir = lspconfig.util.root_pattern("deno.json","deno.jsonc")}
    opts = vim.tbl_deep_extend("force", deno_opts, opts)
  end
  -- if server == "tsserver" then
  --   local deno_opts = {root_dir = lspconfig.util.root_pattern("tsserver.json")}
  --   opts = vim.tbl_deep_extend("force", deno_opts, opts)
  -- end
  if server == "sumneko_lua" then
    local sumneko_opts = require "user.lsp.settings.sumneko_lua"
    opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
  end

  if server == "pyright" then
    local pyright_opts = require "user.lsp.settings.pyright"
    opts = vim.tbl_deep_extend("force", pyright_opts, opts)
  end

  if server == "jdtls" then goto continue end

  lspconfig[server].setup(opts)
  ::continue::
end
