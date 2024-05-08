local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
local svelte_augroup = vim.api.nvim_create_augroup("kickstart-lsp-svelte", { clear = true })

local svelte_capabilities = {
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	},
}

-- Extend the original capabilities with Svelte-specific ones
M.capabilities = vim.tbl_deep_extend("force", capabilities, svelte_capabilities)

function M.on_attach(client, bufnr)
	if vim.bo[bufnr].filetype == "svelte" then
		vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufWritePost" }, {
			pattern = { "*.js", "*.ts", "*.svelte" },
			callback = function(ctx)
				client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
			end,
		})
	end
	if client.name == "svelte" then
		vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufWritePost" }, {
			pattern = { "*.js", "*.ts" },
			group = svelte_augroup,
			callback = function(ctx)
				client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
			end,
		})
	end
end
return M
