return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		{ "folke/neodev.nvim", opts = {} },
	},
	keys = {
		{ "gd", require("telescope.builtin").lsp_definitions, desc = "[G]oto [D]efinition" },
		{ "<leader>fr", require("telescope.builtin").lsp_references, desc = "[G]oto [R]eferences" },
		{ "gI", require("telescope.builtin").lsp_implementations, desc = "[G]oto [I]mplementation" },
		{ "<leader>D", ":Alpha<CR>", desc = "Dashboard" },
		{ "<leader>fs", require("telescope.builtin").lsp_document_symbols, desc = "[D]ocument [S]ymbols" },
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
			"<leader>lf",
			"<cmd>lua vim.lsp.buf.format()<cr>",
			desc = "Format",
		},
		{
			"<leader>lr",
			"<cmd>lua vim.lsp.buf.rename()<cr>",
			desc = "LSP rename",
		},
		{
			"<leader>fr",
			function()
				require("telescope.builtin").lsp_references()
			end,
			desc = "find references",
		},
	},

	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					if client.name == "gopls" then
						require("plugins.lsp.gopls").on_attach(client)
					end
					require("plugins.lsp.svelte").on_attach(client, event.buf)
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
			-- denols = {
			-- 	filetypes = { "typescript" },
			-- 	init_options = {
			-- 		enable = true,
			-- 		unstable = true,
			-- 		-- importMap = "/home/stefan/Projects/LeafLinkerBackend/supabase/functions/import_map.json",
			-- 		importMap = "./supabase/functions/import_map.json",
			-- 	},
			-- 	root_dir = require("lspconfig").util.root_pattern("deno.json"),
			-- },
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
			svelte = { capabilities = require("plugins.lsp.svelte") },
			tailwindcss = {},
			vimls = {},
			gopls = require("plugins.lsp.gopls").config,
			lemminx = {},
			rust_analyzer = {},
			gleam = {
				mason = false,
				cmd = { "/run/current-system/sw/bin/gleam", "lsp" },
			},
		}
		require("mason").setup()

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
