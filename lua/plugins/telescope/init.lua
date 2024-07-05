local keys = {
	{
		"<leader>f",
		name = "Find",
	},
{
		"<leader>fB",
		function()
			local theme = require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })
			require("telescope.builtin").current_buffer_fuzzy_find(theme)
		end,
		desc = "Fuzzy Find in Buffer",
	},

	{ "gd",         require("telescope.builtin").lsp_definitions,      desc = "[G]oto [D]efinition" },
	{ "<leader>fr", require("telescope.builtin").lsp_references,       desc = "[f]ind [R]eferences" },
	{ "<leader>fw", require("telescope.builtin").live_grep,       desc = "[f]ind [w]word" },
	{ "<leader>fs", require("telescope.builtin").lsp_document_symbols, desc = "[f]ind [S]ymbols" },
	{ "<leader>fh", require("telescope.builtin").help_tags, desc = "[f]ind [h]help" },
	{
		"<leader>dc",
		"<cmd>lua require('telescope').extensions.diff.diff_current({ hidden = true })<cr>",
		desc = "[d]iff [c]urrent",
	},
	{
		"<leader>df",
		"<cmd>lua require('telescope').extensions.diff.diff_files({ hidden = true })<cr>",
		desc = "[d]iff [f]ile",
	},
	{
		"<leader>fp",
		"<cmd>Telescope projects<cr>",
		desc = "Keymaps",
	},
}

local disabled = {
	"<leader>/",
	"<leader>fr",
	"<leader><space>",
	"<leader>,",
	"<leader>/",
	"<leader>:",
	"<leader>fb",
	"<leader>fc",
	"<leader>ff",
	"<leader>fF",
	"<leader>fg",
	"<leader>fr",
	"<leader>fR",
	"<leader>gc",
	"<leader>gs",
	"<leader>s",
	"<leader>sa",
	"<leader>sb",
	"<leader>sc",
	"<leader>sC",
	"<leader>sd",
	"<leader>sD",
	"<leader>sg",
	"<leader>sG",
	"<leader>sh",
	"<leader>sH",
	"<leader>sk",
	"<leader>sm",
	"<leader>sM",
	"<leader>so",
	"<leader>sR",
	"<leader>ss",
	"<leader>sS",
	"<leader>sw",
	"<leader>sW",
}

for _, key in ipairs(disabled) do
	table.insert(keys, { key, false })
end

return {
	{
		"nvim-telescope/telescope.nvim",
		keys = keys,
		cmd = "Telescope",
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					path_display = { "smart" },
					file_ignore_patterns = { ".git/", "node_modules" },
					mappings = {
						i = {
							["<Down>"] = actions.move_selection_next,
							["<Up>"] = actions.move_selection_previous,
							["<C-Down>"] = actions.cycle_history_next,
							["<C-Up>"] = actions.cycle_history_prev,
							["<C-q>"] = actions.smart_send_to_qflist,
						},
					},
				},
			})
		end,
	},
	require("plugins.telescope.npm"),
	require("plugins.telescope.projects"),
	require("plugins.telescope.diff"),
	require("plugins.telescope.mini-extras"),
	require("plugins.telescope.fzf"),
}
