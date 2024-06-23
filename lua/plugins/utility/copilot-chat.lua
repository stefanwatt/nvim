return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    event = "VeryLazy",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },

    keys = {
      {
        "<leader>cv",
        mode={"v","x"},
        function()
          local input = vim.fn.input("Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require('CopilotChat.select').visual })
          end
        end,
        desc = "CopilotChat - [V]isual",
      },{
        "<leader>cq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - [Q]uick chat",
      }
    },
    opts = {
      debug = true,
    },
  },
}
