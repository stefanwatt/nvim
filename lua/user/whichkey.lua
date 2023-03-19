local status_ok, whichkey = pcall(require, "which-key")
if not status_ok then
  return
end

local setup = {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = false, -- adds help for motions
      text_objects = false, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    ["<leader>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  window = {
    border = "rounded", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "center", -- align columns left, center or right
  },
  ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = false, -- show help message on the command line when the popup is visible
  -- triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
}

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local m_opts = {
  mode = "n", -- NORMAL mode
  prefix = "m",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local m_mappings = {
}

local mappings = {
  -- ["1"] = "which_key_ignore",
  D = { "<cmd>Alpha<cr>", "Dashboard" },
  e = { "<cmd>Telescope file_browser path=%:p:h select_buffer=true initial_mode=normal<cr><Esc>", "Explorer" },
  v = { "<cmd>vsplit<cr>", "vsplit" },
  h = { "<cmd>nohlsearch<CR>", "no highlights" },
  n = { "<cmd>NoNeckPain<CR>", "No neck pain" },
  c = { "<cmd>lua MiniBufremove.delete()<CR>", "Close Buffer" },
  p = {
    name = "Packer",
    c = { "<cmd>PackerCompile<cr>", "Compile" },
    i = { "<cmd>PackerInstall<cr>", "Install" },
    s = { "<cmd>PackerSync<cr>", "Sync" },
    S = { "<cmd>PackerStatus<cr>", "Status" },
    u = { "<cmd>PackerUpdate<cr>", "Update" },
  },
  d = {
    name = "Debug",
    b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
    c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
    i = { "<cmd>lua require'dap'.step_into()<cr>", "Into" },
    o = { "<cmd>lua require'dap'.step_over()<cr>", "Over" },
    O = { "<cmd>lua require'dap'.step_out()<cr>", "Out" },
    r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Repl" },
    l = { "<cmd>lua require'osv'.run_this()<cr>", "Lua debug" },
    u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
    x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
  },

  E = { "<cmd>Dirbuf<cr>", "Dirbuf" },

  f = {
    name = "Find",
    b = { "<cmd>Telescope buffers<cr>", "Buffers" },
    B = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    f = { "<cmd>lua require('telescope').extensions.menufacture.find_files()<cr>", "Find files" },
    w = { "<cmd>lua require('telescope').extensions.menufacture.live_grep()<cr>", "Find word" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Find Symbols" },
    h = { "<cmd>Telescope help_tags<cr>", "Help" },
    r = { "<cmd>Telescope lsp_references<cr>", "References" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    c = { "<cmd>Telescope commands<cr>", "Commands" },
    p = { "<cmd>Telescope projects<cr>", "Keymaps" },
    t = {
      name = "Tasks",
      s = { "<cmd>Telescope tasks specs<cr>", "Specs" },
      r = { "<cmd>Telescope tasks running<cr>", "Running" },
    }
  },

  g = {
    name = "Git",
    g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
    j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
    l = { "<cmd>GitBlameToggle<cr>", "Blame" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    u = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    d = {
      "<cmd>Gitsigns diffthis HEAD<cr>",
      "Diff",
    },
  },

  l = {
    name = "LSP",
    a = { "<cmd>Lspsaga code_action<CR>", "Code Action" },
    d = { "<cmd>Lspsaga show_line_diagnostics<CR>", "Diagnostics" },
    f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
    F = { "<cmd>Lspsaga lsp_finder<CR>", "Toggle Autoformat" },
    i = { "<cmd>LspInfo<cr>", "Info" },
    h = { "<cmd>IlluminationToggle<cr>", "Toggle Doc HL" },
    I = { "<cmd>Mason<cr>", "Installer Info" },
    v = { "<cmd>lua require('lsp_lines').toggle()<cr>", "Toggle Virtual Text" },
    l = { "<cmd>lua vim.diagnostic.config({ virtual_lines = { only_current_line = true } })<cr>", "Virtual Text current line" },
    o = { "<cmd>LSoutlineToggle<CR>"},
    r = { "<cmd>Lspsaga rename<CR>", "Rename" },
    R = { "<cmd>lua vim.lsp.buf.references()<cr>", "References" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    S = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Workspace Symbols",
    },
  },
  P = {
    name = "Project",
    r = { "<cmd>IdeRecentProjects<cr>", "Recent"},
    w = { "<cmd>IdeProjectWrite<cr>", "Save"},
    s = { "<cmd>IdeProjectSettings<cr>", "Settings"},
    d = { "<cmd>IdeProjectDebug<cr>", "Debug"},
    l = { "<cmd>IdeProjectRun<cr>", "Launch"},
    c = { "<cmd>IdeProjectConfigure<cr>", "Config"},
  }
}

local vopts = {
  mode = "v", -- VISUAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}
local vmappings = {
  ["/"] = { "<Esc><cmd>'<,'>CommentToggle<cr>","Comment" },
  r = {
    name = "refactoring",
    e = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<cr>", "Extract Function" },
    f = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<cr>", "Extract Function To File" },
    v = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<cr>", "Extract Variable" },
    i = { "<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<cr>", "Inline Variable" },
  },
}

whichkey.setup(setup)
whichkey.register(mappings, opts)
whichkey.register(vmappings, vopts)
whichkey.register(m_mappings, m_opts)
