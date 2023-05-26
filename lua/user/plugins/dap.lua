return {
  {
    "mfussenegger/nvim-dap",
    commit = "0b320f5bd4e5f81e8376f9d9681b5c4ee4483c25",
    config = function()
      vim.fn.sign_define("DapBreakpoint", { text = "⬤", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
      vim.fn.sign_define('DapStopped', { text = '⏭', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
      local dap = require("dap")

      dap.configurations.java = {
        {
          type = 'java',
          request = 'attach',
          name = "Debug (Attach) - Remote",
          hostName = "0.0.0.0",
          port = 5005,
        },
      }

      dap.adapters.nlua = function(callback, config)
        callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
      end

      dap.adapters.firefox = {
        type = 'executable',
        command = 'node',
        args = { os.getenv('HOME') .. '/dap/vscode-firefox-debug/dist/adapter.bundle.js' },
      }
      for _, language in ipairs({ "typescript", "javascript" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
          {
            name = 'Debug with Firefox',
            type = 'firefox',
            request = 'launch',
            reAttach = true,
            url = 'http://localhost:5173',
            webRoot = '${workspaceFolder}',
            firefoxExecutable = '/usr/bin/firefox'
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require 'dap.utils'.pick_process,
            cwd = "${workspaceFolder}",
          }
        }
      end

      dap.configurations.lua = {
        {
          type = 'nlua',
          request = 'attach',
          name = "Attach to running Neovim instance",
        }
      }
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    commit = "c8ce83a66deb0ca6f5af5a9f9d5fcc05a6d0f66b",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        -- Expand lines larger than the window
        -- Requires >= 0.7
        expand_lines = vim.fn.has("nvim-0.7"),
        -- Layouts define sections of the screen to place windows.
        -- The position can be "left", "right", "top" or "bottom".
        -- The size specifies the height/width depending on position. It can be an Int
        -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
        -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
        -- Elements are the elements shown in the layout (in order).
        -- Layouts are opened in order so that earlier layouts take priority in window sizing.
        layouts = {
          {
            elements = {
              -- Elements can be strings or table with id and size keys.
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40, -- 40 columns
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
          },
        },
        controls = {
          -- Requires Neovim nightly (or 0.8 when released)
          enabled = true,
          -- Display controls in this element
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "↻",
            terminate = "□",
          },
        },
        floating = {
          max_height = nil,  -- These can be integers or a float between 0 and 1.
          max_width = nil,   -- Floats will be treated as percentage of your screen.
          border = "single", -- Border style. Can be "single", "double" or "rounded"
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil, -- Can be integer or nil.
          max_value_lines = 100, -- Can be integer or nil.
        }
      })
    end
  },
  {
    "ravenxrz/DAPInstall.nvim",
    commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de",
    config = function()
      local dap_install = require("dap-install")
      dap_install.setup {}

      dap_install.config("python", {})
    end
  },
  -- lua debug adapter
  { "jbyuki/one-small-step-for-vimkind", commit = "ccd671fedaca36e474aadfdd70b9ca4189fcd86e" },
  {
    "mxsdev/nvim-dap-vscode-js",
    commit = "079d0f3713c4649603290dc2ecc765e23e76a9fc",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-vscode-js").setup({
        node_path = os.getenv('HOME') .. '/.nvm/versions/node/v18.2.0/bin/node',
        debugger_path = os.getenv('HOME') .. '/vscode-js-debug/',
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
      })
    end
  },
}
