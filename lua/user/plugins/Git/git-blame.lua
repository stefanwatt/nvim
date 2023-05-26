return {
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    config = function()
      vim.g.gitblame_enabled = 0
      vim.g.gitblame_ignored_filetypes = { 'NvimTree', 'alpha' }
    end
  },
}
