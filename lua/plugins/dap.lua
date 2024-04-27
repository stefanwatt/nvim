local disabled_keys = {
	"<leader>td",
	"<leader>tl",
	"<leader>to",
	"<leader>tO",
	"<leader>r",
	"<leader>s",
	"<leader>S",
	"<leader>T",
}

local keys = {
	{
		"<leader>tt",
		mode = { "n" },
		"<CMD>Trouble<CR>",
		desc = "Toggle Trouble",
	},
	{

		"<leader>tt",
		mode = { "n" },
		"<CMD>Trouble<CR>",
		desc = "Toggle Trouble",
	},
}

for _, key in ipairs(disabled_keys) do
	table.insert(keys, { key, false })
end

return {
	{
		"mfussenegger/nvim-dap",
		optional = true,
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = function(_, opts)
					opts.ensure_installed = opts.ensure_installed or {}
					table.insert(opts.ensure_installed, "js-debug-adapter")
				end,
			},
			"leoluz/nvim-dap-go",
		},
		keys = keys,
		opts = function()
			local dap = require("dap")
			if not dap.adapters["pwa-node"] then
				require("dap").adapters["pwa-node"] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = os.getenv("NODE"),
						-- 💀 Make sure to update this path to point to your installation
						args = {
							require("mason-registry").get_package("js-debug-adapter"):get_install_path()
								.. "/js-debug/src/dapDebugServer.js",
							"${port}",
						},
					},
				}
			end
			for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
				if not dap.configurations[language] then
					dap.configurations[language] = {
						{
							type = "pwa-node",
							request = "launch",
							name = "Launch file",
							program = "${file}",
							cwd = "${workspaceFolder}",
						},
						{
							type = "pwa-node",
							request = "attach",
							name = "Attach",
							processId = require("dap.utils").pick_process,
							cwd = "${workspaceFolder}",
						},
					}
				end
			end
		end,
		-- require("dap-go").setup({
		-- 	dap_configurations = {
		-- 		{
		-- 			type = "go",
		-- 			name = "Attach remote",
		-- 			mode = "remote",
		-- 			request = "attach",
		-- 			debugAdapter = "legacy",
		-- 			port = 2345,
		-- 			host = "127.0.0.1",
		-- 		},
		-- 	},
		-- }),
	},
}
