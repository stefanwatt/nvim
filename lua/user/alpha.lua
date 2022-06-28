local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local dashboard = require "alpha.themes.dashboard"
dashboard.section.header.val = {
  [[                               __                ]],
  [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
  [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
  [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
  [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
  [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
}
local startify = require "alpha.themes.startify"
local button = startify.button
local favorites = {
  type = "group",
  val = {
    button("i", "bspwm config", ":e ~/.config/bspwm/bspwmrc.mjs<CR>"),
    button("n", "nvim config", ":e ~/.config/nvim/init.lua<CR>"),
    button("p", "projects", ":Telescope projects<CR>"),
  },
}
local section = startify.section
startify.config.layout = {
  { type = "padding", val = 1 },
  section.header,
  { type = "padding", val = 2 },
  section.top_buttons,
  favorites,
  { type = "padding", val = 1 },
  section.mru,
  { type = "padding", val = 1 },
  section.bottom_buttons,
  section.footer,
}
alpha.setup(startify.config)
