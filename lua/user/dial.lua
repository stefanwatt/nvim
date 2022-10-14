local augend = require("dial.augend")
require("dial.config").augends:register_group{
  -- default augends used when no group name is specified
  default = {
    augend.integer.alias.decimal,   -- nonnegative decimal number (0, 1, 2, 3, ...)
    augend.integer.alias.hex,       -- nonnegative hex number  (0x01, 0x1a1f, etc.)
    augend.date.alias["%Y/%m/%d"],  -- date (2022/02/19, etc.)
  },

  -- augends used when group with name `mygroup` is specified
  mygroup = {
    augend.integer.alias.decimal,
    augend.constant.alias.bool,    -- boolean value (true <-> false)
    augend.date.alias["%m/%d/%Y"], -- date (02/19/2022, etc.)
    augend.constant.new{
      elements = {"==", "!="},
      word = false,
      cyclic = true,
    },
    augend.constant.new{
      elements = {"===", "!=="},
      word = false,
      cyclic = true,
    },
    augend.constant.new{
      elements = {"&&", "||"},
      word = false,
      cyclic = true,
    },
  }
}
vim.api.nvim_set_keymap("n", "<Leader>s", require("dial.map").inc_normal("mygroup"), {noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>S", require("dial.map").dec_normal("mygroup"), {noremap = true})
