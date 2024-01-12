require("lspconfig").lua_ls.setup({
	mason = false,
	on_init = function(client)
		local path = client.workspace_folders[1].name
		local found_luarc = vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc")
		if not found_luarc then
			client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = {
							"require",
							"vim",
							"jit",
							"MiniPick",
							"MiniExtra",
							"MiniFiles",
							"len",
						},
					},
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
						},
					},
				},
			})

			client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		end
		return true
	end,
})
