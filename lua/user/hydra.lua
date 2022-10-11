local Hydra = require('hydra')
local diagnostics_hint = [[
 _n_: next diagnostic
 _p_: previous diagnostic
]]
local diagnostics_hydra = Hydra({
  name = "Diagnostics",
  mode = 'n',
  hint = diagnostics_hint,
  heads = {
    { 'n', "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>" },
    { 'p', "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<CR>" },
  },
  config = {
    hint = {
      border = "rounded",
      position = "middle-right",
      type = "window"
    }
  }
})
vim.api.nvim_create_user_command("HydraActivateDiagnostics", function()
	diagnostics_hydra:activate()
end, {})
