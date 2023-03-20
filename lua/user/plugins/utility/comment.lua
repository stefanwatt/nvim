return {
  'echasnovski/mini.comment',
  version = '*',
  keys = {
    { "<leader>/"}
  },
  config = function()
    local status_ok, comment = pcall(require, "mini.comment")
    if not status_ok then
      return
    end

    comment.setup {
      -- Options which control module behavior
      options = {
        -- Whether to ignore blank lines when adding comment
        ignore_blank_line = false,
        -- Whether to recognize as comment only lines without indent
        start_of_line = false,
      },

      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Toggle comment (like `gcip` - comment inner paragraph) for both
        -- Normal and Visual modes
        comment = '<leader>/',
        -- Toggle comment on current line
        comment_line = '<leader>/',
        -- Define 'comment' textobject (like `dgc` - delete whole comment block)
        textobject = 'gc',
      },

      -- Hook functions to be executed at certain stage of commenting
      hooks = {
        -- Before successful commenting. Does nothing by default.
        pre = function()
        end,
        -- After successful commenting. Does nothing by default.
        post = function()
        end,
      },
    }
  end
}