return {
  {
    "stefanwatt/noice.nvim",
    event = "VeryLazy",
    -- enabled = false,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("noice").setup({
        lsp = {
          signature = {
            enabled = false
          },
          hover = {
            enabled = false
          }
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = false,          -- use a classic bottom cmdline for search
        },
        messages = {
          enabled = false, -- enables the Noice messages UI
        },
        notify = {
          enabled = false,
        },
        views = {
          cmdline_popup = {
            position = {
              row = "40%",
              col = "50%",
            },
            size = {
              width = 60,
              height = "auto",
            },
          },
          popupmenu = {
            relative = "editor",
            position = {
              row = "55%",
              col = "50%",
            },
            size = {
              width = 60,
              height = 10,
            },
            border = {
              style = "rounded",
              padding = { 0, 1 },
            },
            win_options = {
              winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
            },
          },
        },
      })
    end,
  },
}
