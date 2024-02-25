return {
	{
		"folke/noice.nvim",
		enabled = false,
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			--create new buffer
			local substitute_buf = vim.api.nvim_create_buf(true, false)
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = false, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
				messages = {
					enabled = false, -- enables the Noice messages UI
				},
				notify = {
					enabled = false,
				},
				---@type NoiceRouteConfig[]
				routes = {
					{
						filter = {
							-- cmdline = true,
							find = ":s/",
						},
						view = "cmdline_popup",
						opts = {
							buf_options = { substitute_buf },
							render = function(buf, _, _, config)
								print("nui buffer: " .. tostring(buf))
								print(vim.inspect(config))
							end,
						},
					},
				},
				views = {
					cmdline_popup = {
						position = {
							row = "40%",
							col = "50%",
						},
						size = {
							width = 60,
							height = "auto",
						},
					},
					popupmenu = {
						relative = "editor",
						position = {
							row = "55%",
							col = "50%",
						},
						size = {
							width = 60,
							height = 10,
						},
						border = {
							style = "rounded",
							padding = { 0, 1 },
						},
						win_options = {
							winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
						},
					},
				},
			})
		end,
	},
}
