return {
  { "mfussenegger/nvim-dap", commit = "0b320f5bd4e5f81e8376f9d9681b5c4ee4483c25"},
  { "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    commit = "c8ce83a66deb0ca6f5af5a9f9d5fcc05a6d0f66b",
  },
  { "ravenxrz/DAPInstall.nvim", commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de" },
  -- lua debug adapter
  { "jbyuki/one-small-step-for-vimkind", commit = "ccd671fedaca36e474aadfdd70b9ca4189fcd86e" },
  { "mxsdev/nvim-dap-vscode-js",
    commit = "079d0f3713c4649603290dc2ecc765e23e76a9fc",
    dependencies = { "mfussenegger/nvim-dap" }
  },
}
