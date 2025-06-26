-- return {
-- 	"echasnovski/mini.files",
-- 	version = false,
-- 	keys = {
-- 		{
-- 			"<leader>e",
-- 			mode = { "n", "x", "o" },
-- 			":lua MiniFiles.open()<cr>",
-- 			desc = "MiniFiles",
-- 		},
-- 	},
-- 	config = function()
-- 		require("mini.files").setup({
-- 			mappings = {
-- 				close = "q",
-- 				go_in_plus = "<Right>",
-- 				go_out_plus = "<Left>",
-- 				synchronize = "=",
-- 			},
-- 			windows = {
-- 				preview = true,
-- 				max_number = 3,
-- 			},
-- 		})
-- 	end,
-- }
return {
  "trek.nvim",
  name = "trek.nvim",
  dir = "/home/stefan/Projects/trek.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  keys = {
    {
      "<leader>e",
      mode = { "n" },
      function()
        require("trek").open(vim.api.nvim_buf_get_name(0))
      end,
      desc = "File Explorer",
    },
  },
  config = function()
    require("trek").setup({
      keymaps = {
        close = "q",
        go_in = "<Right>",
        go_out = "<Left>",
        synchronize = "=",
      }
    });
  end
}
