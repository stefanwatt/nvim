return {
  {
    "Tummetott/reticle.nvim",
    event="VeryLazy",
    config = function()
      require('reticle').setup({
        follow = {
          cursorline = true,
          cursorcolumn = true,
        },
        always = {
          cursorline = {},
          cursorcolumn = {},
        },
        on_focus = {
          cursorline = {},
          cursorcolumn = {},
        },
        never = {
          cursorline = {
            'TelescopePrompt',
            'DressingInput',
          },
          cursorcolumn = {},
        },
        ignore = {
          cursorline = {},
          cursorcolumn = {},
        },
        always_show_cl_number = false,
      })
    end
  }
}
