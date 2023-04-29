return {
  {
    "kdheepak/lazygit.nvim",
    commit = "9c73fd69a4c1cb3b3fc35b741ac968e331642600",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Lazygit" }
    }
  },
  require("user.plugins.Git.gitsigns"),
  require("user.plugins.Git.git-blame"),
}
