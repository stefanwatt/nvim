require("auto-save").setup({
  -- The name of the augroup.
  augroup_name = "AutoSavePlug",

  -- The events in which to trigger an auto save.
  events = { "InsertLeave", "TextChanged" },

  -- If you'd prefer to silence the output of `save_fn`.
  silent = true,

  -- If you'd prefer to write a vim command.
  save_cmd = nil,

  -- What to do after checking if auto save conditions have been met.
  save_fn = function()
    local config = require("auto-save.config")
    if config.save_cmd ~= nil then
      vim.cmd(config.save_cmd)
    else
      vim.cmd("w")
    end
    print("autosaved")
  end,

  -- May define a timeout, or a duration to defer the save for - this allows
  -- for formatters to run, for example if they're configured via an autocmd
  -- that listens for `BufWritePre` event.
  timeout = nil,

  -- Define some filetypes to explicitly not save, in case our existing conditions
  -- don't quite catch all the buffers we'd prefer not to write to.
  exclude_ft = {""},
})
