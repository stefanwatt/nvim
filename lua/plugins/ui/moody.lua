local default =  "#494d64"
return {
    "svampkorg/moody.nvim",
    event = { "ModeChanged", "BufWinEnter", "WinEnter" },
    dependencies = {
        "catppuccin/nvim",
    },
    opts = {
        -- you can set different blend values for your different modes.
        -- Some colours might look better more dark, so set a higher value
        -- will result in a darker shade.
        blends = {
            normal = 1,
            insert = 0.65,
            visual = 0.4,
            command = 1,
            operator = 1,
            replace = 1,
            select = 1,
            terminal = 1,
            terminal_n = 1,
        },
        colors = {
            normal = default,
            insert = "#496164",
            visual = "#c6a0f6",
            command = default,
            replace = "#ed8796",
            operator =default,
            select =default,
            terminal =default,
            terminal_n =default,
        },
        -- disable filetypes here. Add for example "TelescopePrompt" to
        -- not have any coloured cursorline for the telescope prompt.
        disabled_filetypes = { "TelescopePrompt" },
        -- you can turn on or off bold characters for the line numbers
        bold_nr = true,
    },
  }
