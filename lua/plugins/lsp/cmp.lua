return {
	{
		"saghen/blink.cmp",
		lazy = false, -- lazy loading handled internally
		-- optional: provides snippets for the snippet source
		dependencies = "rafamadriz/friendly-snippets",

		-- use a release tag to download pre-built binaries
		version = "v0.*",
		-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',

		opts = {
			keymap = "default",
			highlight = {
				use_nvim_cmp_as_default = true,
			},
			nerd_font_variant = "normal",
			windows = {
				autocomplete = { border = "rounded" },
				documentation = { border = "rounded" },
				signature_help = { border = "rounded" },
			},
		},
	},
	-- "yioneko/nvim-cmp",
	-- branch = "perf-up",
	-- commit = "a475d8b8b282fda2d18f9fbdebba401b405cfecd",
	-- event = "InsertEnter",
	-- dependencies = {
	-- 	"hrsh7th/cmp-nvim-lsp",
	-- 	"hrsh7th/cmp-path",
	-- },
	-- config = function()
	-- 	-- See `:help cmp`
	-- 	local cmp = require("cmp")
	-- 	local window_config = cmp.config.window.bordered()
	-- 	window_config = vim.tbl_deep_extend('force',window_config, {
	-- 		winblend = 0
	-- 	})
	-- 	local luasnip = require("luasnip")
	-- 	luasnip.config.setup({})
	--
	-- 	cmp.setup.filetype('markdown', {
	-- 		sources = {
	-- 			{ name = 'buffer' },
	-- 			{ name = 'path' },
	-- 		},
	-- 	})
	--
	-- 	cmp.setup.filetype('norg', {
	-- 		sources = {
	-- 			{ name = 'buffer' },
	-- 			{ name = 'path' },
	-- 		},
	-- 	})
	--
	-- 	cmp.setup({
	-- 		window = {
	-- 			completion = window_config,
	-- 			documentation = window_config,
	-- 		},
	-- 		snippet = {
	-- 			expand = function(args)
	-- 				luasnip.lsp_expand(args.body)
	-- 			end,
	-- 		},
	-- 		completion = { completeopt = "menu,menuone,noinsert" },
	-- 		mapping = cmp.mapping.preset.insert({
	-- 			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
	-- 			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
	-- 			["<C-b>"] = cmp.mapping.scroll_docs(-4),
	-- 			["<C-f>"] = cmp.mapping.scroll_docs(4),
	-- 			["<C-Space>"] = cmp.mapping.complete(),
	-- 			["<C-e>"] = cmp.mapping.abort(),
	-- 			["<C-y>"] = cmp.mapping.confirm({ select = true }),
	-- 			["<S-CR>"] = cmp.mapping.confirm({
	-- 				behavior = cmp.ConfirmBehavior.Replace,
	-- 				select = true,
	-- 			}),
	-- 			["<C-CR>"] = function(fallback)
	-- 				cmp.abort()
	-- 				fallback()
	-- 			end,
	-- 		}),
	-- 		sources = cmp.config.sources({
	-- 			{ name = "lazydev" },
	-- 			{ name = "luasnip" },
	-- 			{ name = "nvim_lsp" },
	-- 			{ name = "path" },
	-- 		}),
	-- 		formatting = {
	-- 			format = function(_, item)
	-- 				local icons = require("config.utils").cmp_icons.kinds
	-- 				if icons[item.kind] then
	-- 					item.kind = icons[item.kind] .. item.kind
	-- 				end
	-- 				return item
	-- 			end,
	-- 		},
	-- 	})
	-- end,
}
