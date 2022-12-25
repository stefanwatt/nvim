local keymap = vim.keymap.set
local saga = require('lspsaga')

saga.init_lsp_saga()
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
