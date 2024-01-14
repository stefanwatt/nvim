return {
	"mfussenegger/nvim-lint",
	event = "BufReadPre",
  enabled =false,
	opts = {
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
	},
	config = function()
		require("lint").linters_by_ft = {
			svelte = { "eslint_d" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			lua = { "luacheck" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
