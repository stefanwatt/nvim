--- Control whether to enable workspace diagnostics.
--- This can slow down gopls in ginormous projects.
local workspace_diagnostics_enabled = true

return {
	{
		"stevearc/conform.nvim",
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = function(_, opts)
					opts.ensure_installed = opts.ensure_installed or {}
					vim.list_extend(opts.ensure_installed, { "gofumpt", "goimports", "gci", "golines" })
				end,
			},
		},
		ft = { "go", "gomod", "gowork", "gotmpl" },
		opts = {
			formatters_by_ft = {
				go = { "gofumpt", "goimports", "gci", "golines" },
			},
			formatters = {
				gofumpt = {
					prepend_args = { "-extra" },
				},
				gci = {
					args = {
						"write",
						"--skip-generated",
						"-s",
						"standard",
						"-s",
						"default",
						"--skip-vendor",
						"$FILENAME",
					},
				},
				goimports = {
					args = { "-srcdir", "$FILENAME" },
				},
				golines = {
					-- golines will use goimports as base formatter by default which is slow.
					-- see https://github.com/segmentio/golines/issues/33
					prepend_args = { "--base-formatter=gofumpt", "--ignore-generated", "--tab-len=1", "--max-len=120" },
				},
			},
		},
	},
	{
		"nvim-neotest/neotest",
		ft = { "go" },
		dependencies = {
			"fredrikaverpil/neotest-golang",
		},

		opts = function(_, opts)
			opts.adapters = opts.adapters or {}
			opts.adapters["neotest-golang"] = {
				go_test_args = {
					"-v",
					-- "-count=1",
					"-race",
					-- "-p=1",
					"-parallel=1",
					"-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
				},

				-- experimental
				dev_notifications = true,
				runner = "gotestsum",
				gotestsum_args = { "--format=standard-verbose" },
				-- testify_enabled = true,
			}
		end,
	},

	{
		"andythigpen/nvim-coverage",
		ft = { "go" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- https://github.com/andythigpen/nvim-coverage/blob/main/doc/nvim-coverage.txt
			auto_reload = true,
			lang = {
				go = {
					coverage_file = vim.fn.getcwd() .. "/coverage.out",
				},
			},
		},
	},

	{
		"mfussenegger/nvim-dap",
		ft = { "go" },
		dependencies = {
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = {
					"williamboman/mason.nvim",
				},
				opts = {
					ensure_installed = { "delve" },
				},
			},
			{
				"leoluz/nvim-dap-go",
				opts = {},
			},
		},
		opts = {
			configurations = {
				go = {
					-- See require("dap-go") source for full dlv setup.
					{
						type = "go",
						name = "Debug test (manually enter test name)",
						request = "launch",
						mode = "test",
						program = "./${relativeFileDirname}",
						args = function()
							local testname = vim.fn.input("Test name (^regexp$ ok): ")
							return { "-test.run", testname }
						end,
					},
				},
			},
		},
	},
}
