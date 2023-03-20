return {
  {
    'molecule-man/telescope-menufacture',
    cmd="Telescope",
    dependencies = { "nvim-telescope/telescope.nvim"},
    config = function()
      require('telescope').load_extension "menufacture"
    end
  }
}
