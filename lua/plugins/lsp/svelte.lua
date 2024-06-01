local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

local svelte_capabilities = {
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	},
}

M.capabilities = vim.tbl_deep_extend("force", capabilities, svelte_capabilities)

local group = vim.api.nvim_create_augroup("svelte_ondidchangetsorjsfile", { clear = true })
function M.on_attach(client, buf)
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufWritePost" }, {
		pattern = { "*.js", "*.ts" },
		callback = function(ctx)
			if client.name == "svelte" then
				client.notify("$/onDidChangeTsOrJsFile", {
					uri = ctx.file,
					-- changes = {
					-- 	text = table.concat(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false), "\n"),
					-- },
				})
			end
		end,
	})
end

return M
