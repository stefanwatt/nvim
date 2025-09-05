local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup("nix"),
	pattern = "*.nix",
	callback = function()
		vim.lsp.inlay_hint.enable(false)
	end,
})

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

local persistence_group = augroup("persistence")
vim.api.nvim_create_autocmd("BufWritePost", {
	group = persistence_group,
	pattern = "*",
	callback = function()
		require("persistence").save()
	end,
})

local home = vim.fn.expand("~")
local disabled_dirs = {
	home,
	home .. "/Downloads",
	"/private/tmp",
}

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = persistence_group,
	callback = function()
		local cwd = vim.fn.getcwd()
		for _, path in pairs(disabled_dirs) do
			if path == cwd then
				require("persistence").stop()
				return
			end
		end
		if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
			require("persistence").load()
		else
			require("persistence").stop()
		end
	end,
	nested = true,
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

-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	group = augroup("auto-session"),
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.cmd("SessionRestore")
-- 	end,
-- })

-- vim.api.nvim_create_autocmd({ "BufWritePre", "WinNew", "BufEnter" }, {
-- 	group = augroup("auto-session"),
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.cmd("SessionSave")
-- 	end,
-- })

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

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	command = "checktime",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"query",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

vim.cmd([[
augroup jdtls_lsp
    autocmd!
    autocmd FileType java lua require"plugins.lsp.jdtls".setup()
augroup end
]])

-- vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
-- 	callback = function()
-- 		local cwd = vim.fn.getcwd()
-- 		local target_dir = vim.fn.expand("~/Projects/code-entry")
-- 		if not vim.startswith(cwd, target_dir) then
-- 			return
-- 		end
-- 		vim.cmd("tabnew")
-- 		vim.cmd(
-- 			"terminal sh -c 'kill -9 $(lsof -ti:4200) 2>/dev/null; cd "
-- 				.. target_dir
-- 				.. "/frontend/ui && rm -rf .angular && npm start'"
-- 		)
-- 		local frontend_buf = vim.api.nvim_get_current_buf()
-- 		vim.keymap.set("n", "<leader>rr", function()
-- 			vim.api.nvim_buf_delete(frontend_buf, { force = true })
-- 			vim.cmd("terminal sh -c 'cd " .. target_dir .. "/frontend/ui && rm -rf .angular && npm start'")
-- 		end, { buffer = frontend_buf, desc = "Restart frontend" })
-- 		vim.cmd("split")
-- 		vim.cmd("terminal sh -c 'cd " .. target_dir .. "/backend-minimal && quarkus dev'")
-- 		local backend_buf = vim.api.nvim_get_current_buf()
-- 		vim.keymap.set("n", "<leader>rr", function()
-- 			vim.api.nvim_buf_delete(backend_buf, { force = true })
-- 			vim.cmd(
-- 				"terminal sh -c 'kill -9 $(lsof -ti:8080) 2>/dev/null; cd "
-- 					.. target_dir
-- 					.. "/backend-minimal && quarkus dev'"
-- 			)
-- 		end, { buffer = backend_buf, desc = "Restart backend" })
-- 		vim.cmd("tabprevious")
-- 		vim.schedule(vim.notify("Starting code-entry dev servers...", vim.log.levels.INFO))
-- 	end,
-- })
