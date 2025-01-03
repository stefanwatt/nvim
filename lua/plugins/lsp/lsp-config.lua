return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"yioneko/nvim-cmp",
			branch = "perf-up",
			commit = "a475d8b8b282fda2d18f9fbdebba401b405cfecd",
			event = "InsertEnter",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
			},
		},
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
			"<leader>lo",
			"<cmd>LSoutlineToggle<CR>",
			desc = "Toggle Outline",
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
			"<leader>lf",
			"<cmd>lua vim.lsp.buf.format()<cr>",
			desc = "Format",
		},
		{
			"<leader>lr",
			"<cmd>lua vim.lsp.buf.rename()<cr>",
			desc = "LSP rename",
		},
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				vim.lsp.inlay_hint.enable(true)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
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
				vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event.buf })
			end,
		})
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local servers = {
			pyright = {},
			angularls = {},
			astro = {},
			bashls = {},
			cssls = {},
			eslint = {},
			html = {},
			lua_ls = require("plugins.lsp.lua-ls"),
			marksman = { mason = false, cmd = { "/run/current-system/sw/bin/marksman", "server" } },
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
			-- gopls = require("plugins.lsp.gopls").config,
			gopls = {},
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
			gleam = {
				mason = false,
				cmd = { "/home/stefan/.nix-profile/bin/gleam", "lsp" },
			},
			jdtls = {},
			taplo = {},
		}

		require("mason").setup()
		require("mason-lspconfig").setup()

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			-- 'stylua',
		})
		local lspconfig = require("lspconfig")
		for server, opts in pairs(servers) do
			lspconfig[server].setup(opts)
		end
	end,
}
