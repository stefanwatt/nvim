local dap_icons = {
	Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
	Breakpoint = " ",
	BreakpointCondition = " ",
	BreakpointRejected = { " ", "DiagnosticError" },
	LogPoint = ".>",
}

return {

	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {
			{
				"jbyuki/one-small-step-for-vimkind",
				keys = {
					{
						"<leader>dl",
						function()
							require("osv").launch({ port = 8086 })
						end,
						desc = "launch nlua adapter",
					},
				},
			},
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = {
					"williamboman/mason.nvim",
				},
				cmd = { "DapInstall", "DapUninstall" },
				opts = {
					-- Makes a best effort to setup the various debuggers with
					-- reasonable debug configurations
					automatic_installation = true,

					-- You can provide additional configuration to the handlers,
					-- see mason-nvim-dap README for more information
					handlers = {},

					-- You'll need to check that you have the required things installed
					-- online, please don't ask me how to install them :)
					ensure_installed = {
						-- Update this to ensure that you have the debuggers for the langs you want
					},
				},
			},
		},
		config = function(_, opts)
			-- Set nice color highlighting at the stopped line
			-- vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			-- Show nice icons in gutter instead of the default characters
			for name, sign in pairs(dap_icons) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define("Dap" .. name, {
					text = sign[1],
					texthl = sign[2] or "DiagnosticInfo",
					linehl = sign[3],
					numhl = sign[3],
				})
			end

			local dap = require("dap")
			if opts.configurations ~= nil then
				local merged = require("config.utils").deep_tbl_extend(dap.configurations, opts.configurations)
				dap.configurations = merged
			end
			dap.configurations.lua = {
				{
					type = "nlua",
					request = "attach",
					name = "Attach to running Neovim instance",
				},
			}
			dap.adapters.nlua = function(callback, config)
				callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
			end
		end,
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "toggle [d]ebug [b]reakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "[d]ebug [c]ontinue (start here)",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "[d]ebug step [o]ver",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "[d]ebug step [O]ut",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "[d]ebug [i]nto",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "[d]ebug [l]ast",
			},
			{
				"<leader>dp",
				function()
					require("dap").pause()
				end,
				desc = "[d]ebug [p]ause",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "[d]ebug [r]epl",
			},
			{
				"<leader>dR",
				function()
					require("dap").clear_breakpoints()
				end,
				desc = "[d]ebug [R]emove breakpoints",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "[d]ebug [t]erminate",
			},
		},
	},

	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = {
			"nvim-neotest/nvim-nio",
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
			{
				"mfussenegger/nvim-dap",
				opts = {},
			},
		},
		opts = {},
		config = function(_, opts)
			-- setup dap config by VsCode launch.json file
			-- require("dap.ext.vscode").load_launchjs()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
		keys = {
			{
				"<leader>du",
				function()
					require("dapui").toggle({})
				end,
				desc = "DAP UI",
			},

			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				desc = "DAP Eval",
			},
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		opts = function(_, opts)
			local function dap_status()
				return "  " .. require("dap").status()
			end

			opts.dap_status = {
				lualine_component = {
					dap_status,
					cond = function()
						-- return package.loaded["dap"] and require("dap").status() ~= ""
						return require("dap").status() ~= ""
					end,
					color = require("config.utils").fgcolor("Debug"),
				},
			}
		end,
	},
}
