return {
	"stevearc/conform.nvim",
	dependencies = {
		"rcarriga/nvim-notify",
	},
	lazy = false,
	keys = {
		{
			"<leader>lf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
		{
			"<leader>lt",
			function()
				vim.g.disable_autoformat = not vim.g.disable_autoformat
				local status = vim.g.disable_autoformat and "disabled" or "enabled"
				local level = vim.g.disable_autoformat and "error" or "info"
				require("notify")("format on save",level, { title = status })
			end,
			mode = "",
			desc = "[T]oggle format on save",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat then
				return
			end
			local disable_filetypes = { c = true, cpp = true }
			return {
				timeout_ms = 500,
				lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			-- You can use a sub-list to tell conform to run *until* a formatter
			-- is found.
			-- javascript = { { "prettierd", "prettier" } },
		},
	},
}
