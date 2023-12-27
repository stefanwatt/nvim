local Layout = require("nui.layout")
local event = require("nui.utils.autocmd").event

local last_search_term = nil -- Global variable to store the last search term
local Input = require("nui.input")

local keymap = require("config.utils").keymap

-- TODO
-- 2. you need to be able to search first(ctrl+f) then hit ctrl+h and have the search term and matches
--    carry over to start replacing
-- 3. Add replace modes/flags (regex, ignore case, match whole word)
--    toggle modes with keymap
--    show mode indicator in the dialog
-- 4. when original buffer is updated -> update matches
-- 5. is multi-line replace working?

keymap("n", "<C-f>", ":SearchDialogToggle<cr>", { noremap = true, silent = true })
keymap("i", "<C-f>", ":SearchDialogToggle<cr>", { noremap = true, silent = true })
keymap("v", "<C-f>", "<cmd>SearchDialogToggle visual<cr>", { noremap = true, silent = true })

keymap("n", "<C-h>", ":SearchAndReplaceDialogToggle<cr>", { noremap = true, silent = true })
keymap("i", "<C-h>", ":SearchAndReplaceDialogToggle<cr>", { noremap = true, silent = true })
keymap("v", "<C-h>", "<esc>:SearchAndReplaceDialogToggle<cr>", { noremap = true, silent = true })
