local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

return {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = runtime_path,
			},
			diagnostics = {
				disable = { "unused-local" },
				globals = {
					"require",
					"vim",
					"jit",
					"MiniPick",
					"MiniExtra",
					"len",
				},
			},
			workspace = {
				checkThirdParty = false,
				library = {
					"/home/stefan/.local/share/nvim/lazy/neodev.nvim/types/stable",
					"/nix/store/zzz8s6cgkwb9vnpvgs6rqlp855jcqcsm-neovim-nightly/share/nvim/runtime/lua",
					"/nix/store/zzz8s6cgkwb9vnpvgs6rqlp855jcqcsm-neovim-nightly/share/nvim/runtime/lua/vim/treesitter",
					"/home/stefan/.local/share/nvim/lazy/cmp_luasnip/lua",
					"/home/stefan/.local/share/nvim/lazy/cmp-nvim-lsp/lua",
					"/home/stefan/.local/share/nvim/lazy/LuaSnip/lua",
					"/home/stefan/.local/share/nvim/lazy/nvim/lua",
					"/home/stefan/.local/share/nvim/lazy/neodev.nvim/lua",
					"/home/stefan/.local/share/nvim/lazy/nvim-treesitter/lua",
					"/home/stefan/.local/share/nvim/lazy/nvim-lspconfig/lua",
					"/home/stefan/.local/share/nvim/lazy/mason.nvim/lua",
					"/home/stefan/.local/share/nvim/lazy/mason-lspconfig.nvim/lua",
					"/home/stefan/.local/share/nvim/lazy/nvim-cmp/lua",
					"/home/stefan/.local/share/nvim/lazy/lazy.nvim/lua",
					"/home/stefan/.local/share/nvim/lazy/nvim-notify/lua",
					"/home/stefan/.config/nvim/lua",
					"${3rd}/luv/library",
				},
			},
			completion = {
				callSnippet = "Replace",
			},
		},
	},
}
