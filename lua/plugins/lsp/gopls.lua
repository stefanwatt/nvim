local M = {}

M.config = {
	keys = {
		-- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
		{ "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
	},
	settings = {
		gopls = {
			gofumpt = true,
			codelenses = {
				gc_details = false,
				generate = true,
				regenerate_cgo = true,
				run_govulncheck = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			hints = {
				assignVariableTypes = false,
				compositeLiteralFields = true,
				compositeLiteralTypes = false,
				constantValues = false,
				functionTypeParameters = false,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			analyses = {
				fieldalignment = true,
				nilness = true,
				unusedparams = true,
				unusedwrite = true,
				useany = true,
			},
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
			semanticTokens = true,
		},
	},
}

local lspconfig = require("lspconfig")

function M.on_attach(client)
	local default_capabilities = lspconfig.util.default_config.capabilities
	if not client.server_capabilities.semanticTokensProvider then
		local semantic = default_capabilities.textDocument.semanticTokens
		client.server_capabilities.semanticTokensProvider = {
			full = true,
			legend = {
				tokenTypes = semantic.tokenTypes,
				tokenModifiers = semantic.tokenModifiers,
			},
			range = true,
		}
	end
end

return M
