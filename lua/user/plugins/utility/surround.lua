return {
  'echasnovski/mini.surround',
  version = '*',
  event = "BufWinEnter",
  config = function()
    require("mini.surround").setup(
      {
        custom_surroundings = nil,
        highlight_duration = 500,
        mappings = {
          add = 'ys',     -- Add surrounding in Normal and Visual modes
          delete = 'ds',  -- Delete surrounding
          replace = 'cs', -- Replace surrounding
        },
        n_lines = 1,
        search_method = 'cover',
      }
    )
  end
}
