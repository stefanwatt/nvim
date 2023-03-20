return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      local status_ok, configs = pcall(require, "nvim-treesitter.configs")
      if not status_ok then
        return
      end

      configs.setup({
        ensure_installed = "all", -- one of "all" or a list of languages
        ignore_install = { "" }, -- List of parsers to ignore installing
        highlight = {
          enable = true,    -- false will disable the whole extension
          disable = { "css" }, -- list of language that will be disabled
        },
        autotag = {
          enable = true,
          filetypes = { "html", "svelte" },
        },
        indent = { enable = true, disable = { "python", "css" } },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>",
          },
        },
        rainbow = {
          enable = true,
          -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
          extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
          max_file_lines = nil, -- Do not enable for files with more than n lines, int
          colors = {
            '#ED8796',
            '#A6DA95',
            '#EED49F',
            '#8AADF4',
            '#F5BDE6',
            '#8BD5CA',
            '#B8C0E0',
          }, -- table of hex strings
          -- termcolors = {} -- table of colour name strings
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25,   -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        }
      })

      vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
          underline = true,
          virtual_text = {
            spacing = 5,
            severity_limit = 'Warning',
          },
          update_in_insert = true,
        }
      )

      local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
      parser_config.haxe = {
        install_info = {
          url = "https://github.com/vantreeseba/tree-sitter-haxe",
          files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
          -- optional entries:
          branch = "main",    -- default branch in case of git repo if different from master
        },
        filetype = "haxe",    -- if filetype does not match the parser name
      }
    end
  },
  {
    "nvim-treesitter/playground",
    commit = "1290fdf6f2f0189eb3b4ce8073d3fda6a3658376",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    event = "BufWinEnter",
    url = "https://gitlab.com/HiPhish/nvim-ts-rainbow2",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "windwp/nvim-ts-autotag",
    commit = "5bbdfdaa303c698f060035f37a91eaad8d2f8e27",
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    commit = "4d3a68c41a53add8804f471fcc49bb398fe8de08",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    'Wansmer/treesj',
    keys = { '<space>m', '<space>j', '<space>s' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({ max_join_length = 999, })
    end,
  }
}
