return {
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    tag = "v3.0.0",
    commit = "a40f058c6284855ad6a8b8137b3e312beca4d6aa",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      vim.opt.termguicolors = true

      require('bufferline').setup {
        options = {
          mode = "buffers",                     -- set to "tabs" to only show tabpages instead
          close_command = "bdelete! %d",        -- can be a string | function, see "Mouse actions"
          right_mouse_command = "bdelete! %d",  -- can be a string | function, see "Mouse actions"
          left_mouse_command = "buffer %d",     -- can be a string | function, see "Mouse actions"
          middle_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          custom_filter = function(buf_number, buf_numbers)
            if vim.bo[buf_number].filetype ~= "alpha" then
              return true
            end
            if vim.bo[buf_number].filetype ~= "NvimTree" then
              return true
            end
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true
            }
          },
          separator_style = "thick",
          always_show_bufferline = true,
        }
      }

      local toggle_bufferline = vim.api.nvim_create_augroup("ToggleBufferline", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        callback = function()
          vim.o.showtabline = 0
        end,
        group = toggle_bufferline,
        pattern = "AlphaReady",
      })
      vim.api.nvim_create_autocmd("BufUnload", {
        callback = function()
          vim.o.showtabline = 2
        end,
        group = toggle_bufferline,
        pattern = "<buffer>",
      })
    end
  }
}
