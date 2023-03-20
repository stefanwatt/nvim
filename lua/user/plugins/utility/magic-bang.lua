return {
  {
    "Susensio/magic-bang.nvim",
    cmd = "Bang",
    config = function()
      require("magic-bang").setup(
        {
          bins = {
            awk = "awk",
            hs = "runhaskell",
            jl = "julia",
            lua = "lua",
            m = "octave",
            mak = "make",
            php = "php",
            pl = "perl",
            py = "python3",
            r = "Rscript",
            rb = "ruby",
            scala = "scala",
            sh = "bash",
            tcl = "tclsh",
            tk = "wish",
            node = "node"
          },
          automatic = true,     -- insert shebang on new file when in $PATH
          command = true,       -- define Bang user command
          executable = true,    -- make file executable on exit
          default = "/bin/bash" -- default shebang for `:Bang` without args
        }
      )
    end
  }
}
