return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },

		{
			"folke/neodev.nvim",
			dependencies = {
				{ "Bilal2453/luvit-meta", lazy = true },
			},
			event = "VeryLazy",
			config = function()
				require("neodev").setup({})
			end,
		},
	},
	keys = {
		{ "K", vim.lsp.buf.hover, desc = "Hover Documentation" },

		{
			"gd",
			function()
				local function normalize(res)
					if not res then
						return {}
					end
					return vim.tbl_islist(res) and res or { res }
				end

				local function line_at(bufnr, lnum)
					return (vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1] or "")
				end

				local function looks_like_property_line(s)
					if s:match("function%s") or s:match("=%s*function%s*%(") then
						return false
					end
					if s:match("^%s*export%s+") then
						return false
					end
					if s:match("^%s*[%w_]+%s*[:,]") then
						return true
					end
					local t = s:gsub("%s+", "")
					return t:match("^[%w_]+[,}]") ~= nil
				end

				local function in_export_default_object(bufnr, lnum)
					local start = math.max(0, lnum - 120)
					local lines = vim.api.nvim_buf_get_lines(bufnr, start, lnum + 1, false)
					local saw_export_default, saw_open_after_export = false, false
					for i = #lines, 1, -1 do
						local s = lines[i]
						if s:find("}") then
							break
						end
						if s:find("{") and saw_export_default then
							saw_open_after_export = true
						end
						if s:match("export%s+default") then
							saw_export_default = true
						end
					end
					return saw_export_default and saw_open_after_export
				end

				local function is_default_export_property(item)
					local uri = item.uri or item.targetUri
					local range = item.range or item.targetSelectionRange
					if not uri or not range then
						return false
					end
					local bufnr = vim.uri_to_bufnr(uri)
					local lnum = range.start.line
					local s = line_at(bufnr, lnum)
					return looks_like_property_line(s) and in_export_default_object(bufnr, lnum)
				end

				local function score(item)
					local uri = item.uri or item.targetUri
					local range = item.range or item.targetSelectionRange
					local bufnr = vim.uri_to_bufnr(uri)
					local s = line_at(bufnr, range.start.line)
					if s:match("^%s*export%s+function%s") then
						return 4
					end
					if s:match("^%s*function%s") then
						return 3
					end
					if s:match("^%s*[%w_]+%s*=%s*%(") then
						return 2
					end
					if s:match("^%s*const%s+[%w_]+%s*=%s*%(") then
						return 2
					end
					return 1
				end

				local params = vim.lsp.util.make_position_params()
				vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, _)
					local items = normalize(result)
					if #items == 0 then
						return
					end

					local filtered = {}
					for _, it in ipairs(items) do
						if not is_default_export_property(it) then
							table.insert(filtered, it)
						end
					end
					local candidates = (#filtered > 0) and filtered or items
					table.sort(candidates, function(a, b)
						return score(a) > score(b)
					end)

					vim.lsp.util.jump_to_location(candidates[1], "utf-8")
				end)
			end,
			desc = "[g]oto definition (skip export default props)",
		},
		{ "gD", vim.lsp.buf.declaration, desc = "[G]oto [D]eclaration" },
		{
			"<leader>lR",
			"<cmd>lua vim.lsp.buf.references()<cr>",
			desc = "References",
		},
		{
			"<leader>ll",
			"<cmd>lua vim.diagnostic.config({ virtual_lines = { only_current_line = true } })<cr>",
			desc = "Virtual Text current line",
		},
		{
			"<leader>lI",
			"<cmd>Mason<cr>",
			desc = "Installer Info",
		},
		{
			"<leader>li",
			"<cmd>LspInfo<cr>",
			desc = "Info",
		},
		{
			"<leader>lh",
			"<cmd>IlluminationToggle<cr>",
			desc = "Toggle Doc HL",
		},
		{
			"<leader>lH",
			"<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>",
			desc = "Toggle Inlay Hints",
		},
		{
			"<leader>lr",
			"<cmd>lua vim.lsp.buf.rename()<cr>",
			desc = "[l]sp [r]ename",
		},
		{
			"<leader>la",
			"<cmd>lua vim.lsp.buf.code_action()<cr>",
			desc = "[l]sp [a]ction",
		},
		{
			"<leader>ld",
			function()
				if vim.diagnostic.config().virtual_lines then
					vim.diagnostic.config({ virtual_lines = false })
				else
					vim.diagnostic.config({ virtual_lines = { current_line = true } })
				end
			end,
			desc = "[l]sp toggle [d]iagnostics",
		},
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				vim.lsp.inlay_hint.enable(true)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client.name == "angularls" then
					client.server_capabilities.renameProvider = false
				end
				if client.name == "ts_ls" then
					vim.keymap.set("n", "<leader>lo", function()
						vim.lsp.buf.code_action({
							apply = true,
							context = { only = { "source.organizeImports" } },
						})
						vim.lsp.buf.code_action({
							apply = true,
							context = { only = { "source.removeUnusedImports" } },
						})
					end, { desc = "Remove Unused Imports", buffer = event.buf })
				end
				if client.name == "gopls" then
					require("plugins.lsp.gopls").on_attach(client)
				end
				require("plugins.lsp.svelte").on_attach(client, event.buf)
				if client and client.server_capabilities.documentHighlightProvider then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end,
		})
		vim.api.nvim_create_autocmd("LspDetach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
			callback = function(event)
				vim.lsp.buf.clear_references()
				-- vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event.buf })
			end,
		})
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		-- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local lspconfig = require("lspconfig")
		local servers = {
			pyright = {},
			angularls = {},
			astro = {},
			bashls = {},
			cssls = {},
			erlangls = {},
			eslint = {},
			gleam = {
				mason = false,
				cmd = { "/home/stefan/.nix-profile/bin/gleam", "lsp" },
			},
			ts_ls = {
				filetypes = {
					"javascript",
					"typescript",
				},
				workspace_required = true,
				root_dir = function(fname)
					-- Only attach if we find package.json but NOT angular.json
					local angular_root = lspconfig.util.root_pattern("angular.json", "nx.json")(fname)
					if angular_root then
						return nil
					end
					return lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")(fname)
				end,
			},
			-- denols = {
			-- 	root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
			-- },
			html = {},
			java_language_server = {
				cmd = { "/home/stefan/Projects/java-language-server/dist/lang_server_linux.sh" },
			},
			lua_ls = require("plugins.lsp.lua-ls"),
			marksman = {},
			sqlls = {},
			svelte = {},
			tailwindcss = {},
			vimls = {},
			nil_ls = {
				settings = {
					nix = {
						flake = {
							autoArchive = true,
							autoEvalInputs = true,
						},
					},
				},
			},
			gopls = require("plugins.lsp.gopls").config,
			lemminx = {},
			clangd = {
				cmd = { "/run/current-system/sw/bin/clangd" },
				filetypes = { "arduino", "c", "cpp", "objc", "objcpp", "cuda", "proto" },
				settings = {
					clangd = {
						compilationDatabasePath = "./output",
						fallbackFlags = { "-std=c++17" },
					},
				},
			},
			rust_analyzer = {},
			arduino_language_server = {
				cmd = {
					"/run/current-system/sw/bin/arduino-language-server",
					"-cli-config",
					vim.fn.expand("~/.config/arduino-cli/arduino-cli.yaml"),
					"-cli",
					"/run/current-system/sw/bin/arduino-cli",
					"-clangd",
					vim.fn.expand("~/.local/share/nvim/mason/bin/clangd"),
					"-fqbn",
					"arduino:avr:nano",
				},
				root_dir = require("lspconfig").util.root_pattern(".git", "sketch.yaml", "*.ino", "*.cpp", "*.c"),
				on_attach = function(client)
					print("arduino_language_server attached")
				end,
			},
		}

		require("mason").setup()
		require("mason-lspconfig").setup()

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			-- 'stylua',
		})
		for server, opts in pairs(servers) do
			-- lspconfig[server].setup(opts)
			vim.lsp.config("server", opts)
		end
	end,
}
