return {
  {
    'echasnovski/mini.animate',
    version = false,
    event = "VeryLazy",
    config = function()
      local mouse_scrolled = false
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end
      local animate = require("mini.animate")
      local timing = animate.gen_timing.cubic({ duration = 30, unit = "total" })
      animate.setup(
        {
          open = { enable = true },
          close = { enable = true },
          cursor = {
            enable = true,
            timing = animate.gen_timing.cubic({ duration = 80, unit = "total" }),
            path = animate.gen_path.line({
              predicate = function()
                return true;
              end,
            })

          },
          resize = {
            enable = true,
            timing=timing,
          },
          scroll = {
            enable = true,
            timing=timing,
            subscroll = animate.gen_subscroll.equal({
              predicate = function(total_scroll)
                if mouse_scrolled then
                  mouse_scrolled = false
                  return false
                end
                return total_scroll > 1
              end,
            }),
          },
        }
      )
    end
  },
}
