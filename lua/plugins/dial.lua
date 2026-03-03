return {
  {
    "monaqa/dial.nvim",
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        -- standard group for all files
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
        },
        markdown = {
          augend.integer.alias.decimal, -- keeps standard number cycling (1-5) working
          augend.constant.new({
            elements = { "", "" },
            word = true, -- ensures it only toggles the standalone word, not "yesterday"
            cyclic = true,
          }),
          augend.constant.new({
            elements = {
              "     ",
              "     ",
              "     ",
              "     ",
              "     ",
              "     ",
            }, -- bonus: great for markdown task lists
            word = false,
            cyclic = true,
          }),
        }
      })
    end
  }
}
