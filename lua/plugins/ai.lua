return {
	{
		"folke/sidekick.nvim",
		lazy = false,
		event = "VeryLazy",
		config = function()
			require("sidekick").setup({
				nes = {
					enabled = true,
				},
				copilot = {
					status = {
						enabled = true,
					},
				},
				cli = {
					mux = {
						backend = "tmux",
						enabled = true,
					},
				},
			})
			vim.lsp.enable("copilot")
			vim.lsp.inline_completion.enable()
		end,
  -- stylua: ignore
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if require("sidekick").nes_jump_or_apply() then
          return -- jumped or applied
        end

        -- if you are using Neovim's native inline completions
        if vim.lsp.inline_completion.get() then
          return
        end

        -- any other things (like snippets) you want to do on <tab> go here.

        -- fall back to normal tab
        return "<tab>"
      end,
      mode = { "i", "n" },
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
     {
      "<leader>aa",
      function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end,
      mode = { "n", "v" },
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").select() end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Sidekick Select CLI",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").send({ selection = true }) end,
      mode = { "v" },
      desc = "Sidekick Send Visual Selection",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "v" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<c-.>",
      function() require("sidekick.cli").focus() end,
      mode = { "n", "x", "i", "t" },
      desc = "Sidekick Switch Focus",
    },
  },
	},
}
