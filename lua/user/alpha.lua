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
local file_button = startify.file_button
local favorites = {
  type = "group",
  val = {
    file_button("~/.config/i3/config", "w", "i3wm config"),
    file_button("~/.config/nvim/init.lua", "n", "nvim config"),
    file_button("~/.config/sxhkd/sxhkdrc","k", "keymaps (sxhkd)"),
    button("p", "projects", ":Telescope projects<CR>"),
  },
}
local projectDirectories = require("user.utils").getSubDirectories("~/Projects/")
local projectEntriesStart = 10
local projectEntries = {}
for i,dirname in ipairs(projectDirectories) do
  projectEntries[i] = file_button("~/Projects/"..dirname,tostring(i+projectEntriesStart-1),dirname)
end

local projects = {
  type = "group",
  val = function ()
    return projectEntries
  end
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
  { type = "text", val = "Projects", opts = { hl = "SpecialComment", shrink_margin = false } },
  { type = "padding", val = 1 },
  projects,
  { type = "padding", val = 1 },
  section.bottom_buttons,
  section.footer,
}
alpha.setup(startify.config)
