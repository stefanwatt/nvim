return {
	"echasnovski/mini.comment",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("mini.comment").setup({
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
				comment = "<leader>/",
				-- Toggle comment on current line
				comment_line = "<leader>/",
				comment_visual = "<leader>/",
				-- Define 'comment' textobject (like `dgc` - delete whole comment block)
				textobject = "gc",
			},

			-- Hook functions to be executed at certain stage of commenting
			hooks = {
				pre = function()
					require("ts_context_commentstring.internal").update_commentstring()
				end,
			},
		})
		vim.opt.formatoptions = "jcqlnt"
	end,
}
