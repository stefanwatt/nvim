return {
  "enochchau/nvim-pretty-ts-errors",
  build = "npm install",
	keys={
    {"<leader>ld", function() require('nvim-pretty-ts-errors').show_line_diagnostics() end, desc = "pretty ts-errors" },
	},
}
