return {
  {
    "f-person/git-blame.nvim",
    lazy=false,
    commit = "08e75b7061f4a654ef62b0cac43a9015c87744a2",
    config = function()
      vim.g.gitblame_enabled = 0
      vim.g.gitblame_ignored_filetypes = { 'NvimTree', 'alpha' }
    end
  },
}
