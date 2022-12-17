local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.setup()
require "user.lsp.null-ls"
require "user.lsp.lsp-lines"
