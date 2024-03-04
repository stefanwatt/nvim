-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup("nix"),
	pattern = "*.nix",
	callback = function(args)
		vim.fn.jobstart({ "nixfmt", args.file }, {
			stdout_buffered = true,
			on_stdout = function(_, data)
				if data then
					vim.cmd("checktime")
				end
			end,
		})
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup("persistence"),
	pattern = "*",
	callback = function()
		require("persistence").save()
	end,
})

local golang_organize_imports = function(bufnr, isPreflight)
	local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding(bufnr))
	params.context = { only = { "source.organizeImports" } }

	if isPreflight then
		vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function() end)
		return
	end

	local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
	for _, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.edit then
				vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding(bufnr))
			else
				vim.lsp.buf.execute_command(r.command)
			end
		end
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspFormatting", {}),
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if client.name == "gopls" then
			-- hack: Preflight async request to gopls, which can prevent blocking when save buffer on first time opened
			golang_organize_imports(bufnr, true)

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				group = vim.api.nvim_create_augroup("LspGolangOrganizeImports." .. bufnr, {}),
				callback = function()
					golang_organize_imports(bufnr)
				end,
			})
		end
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	group = augroup("auto-session"),
	pattern = "*",
	callback = function()
		vim.cmd("SessionRestore")
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre", "WinNew", "BufEnter" }, {
	group = augroup("auto-session"),
	pattern = "*",
	callback = function()
		vim.cmd("SessionSave")
	end,
})

local function set_cwd_if_file_exists()
	local cwd_file_path = vim.fn.expand("%:p:h") .. "/cwd.lua"
	if vim.fn.filereadable(cwd_file_path) == 1 then
		local cwd_change = loadfile(cwd_file_path)()
		local new_cwd = vim.fn.fnamemodify(cwd_file_path, ":h:h") .. "/" .. cwd_change
		vim.api.nvim_set_current_dir(new_cwd)
	end
end

vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup("CwdAdjustment"),
	pattern = "*", -- Apply to all files
	callback = set_cwd_if_file_exists,
})
