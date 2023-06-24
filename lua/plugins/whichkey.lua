return {
	{
		"folke/which-key.nvim",
		lazy = false,
		config = function()
			local whichkey = require("which-key")
			local setup = {
				plugins = {
					marks = true, -- shows a list of your marks on ' and `
					registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
					spelling = {
						enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
						suggestions = 20, -- how many suggestions should be shown in the list?
					},
					-- the presets plugin, adds help for a bunch of default keybindings in Neovim
					-- No actual key bindings are created
					presets = {
						operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
						motions = false, -- adds help for motions
						text_objects = false, -- help for text objects triggered after entering an operator
						windows = true, -- default bindings on <c-w>
						nav = true, -- misc bindings to work with windows
						z = true, -- bindings for folds, spelling and others prefixed with z
						g = true, -- bindings for prefixed with g
					},
				},
				-- add operators that will trigger motion and text object completion
				-- to enable all native operators, set the preset / operators plugin above
				-- operators = { gc = "Comments" },
				key_labels = {
					-- override the label used to display some keys. It doesn't effect WK in any other way.
					-- For example:
					-- ["<space>"] = "SPC",
					["<leader>"] = "SPC",
					-- ["<cr>"] = "RET",
					-- ["<tab>"] = "TAB",
				},
				icons = {
					breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
					separator = "➜", -- symbol used between a key and it's label
					group = "+", -- symbol prepended to a group
				},
				popup_mappings = {
					scroll_down = "<c-d>", -- binding to scroll down inside the popup
					scroll_up = "<c-u>", -- binding to scroll up inside the popup
				},
				window = {
					border = "rounded", -- none, single, double, shadow
					position = "bottom", -- bottom, top
					margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
					padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
					winblend = 0,
				},
				layout = {
					height = { min = 4, max = 25 }, -- min and max height of the columns
					width = { min = 20, max = 50 }, -- min and max width of the columns
					spacing = 3, -- spacing between columns
					align = "center", -- align columns left, center or right
				},
				ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
				hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
				show_help = false, -- show help message on the command line when the popup is visible
				-- triggers = "auto", -- automatically setup triggers
				-- triggers = {"<leader>"} -- or specify a list manually
				triggers_blacklist = {
					-- list of mode / prefixes that should never be hooked by WhichKey
					-- this is mostly relevant for key maps that start with a native binding
					-- most people should not need to change this
					i = { "j", "k" },
					v = { "j", "k" },
				},
			}

			local opts = {
				mode = "n", -- NORMAL mode
				-- prefix: use "<leader>f" for example for mapping everything related to finding files
				-- the prefix is prepended to every mapping part of `mappings`
				prefix = "",
				buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
				silent = true, -- use `silent` when creating keymaps
				noremap = true, -- use `noremap` when creating keymaps
				nowait = false, -- use `nowait` when creating keymaps
				expr = false, -- use `expr` when creating keymaps
			}

			local mappings = {
				-- ["1"] = "which_key_ignore",
				D = { "<cmd>Alpha<cr>", "Dashboard" },
				e = { "<cmd>lua MiniFiles.open()<cr>", "File Explorer" },
				v = { "<cmd>vsplit<cr>", "vsplit" },
				H = { "<cmd>nohlsearch<CR>", "no highlights" },
				n = { "<cmd>NoNeckPain<CR>", "No neck pain" },
				c = { "<cmd>lua MiniBufremove.delete()<CR>", "Close Buffer" },
				C = { "<cmd>MiniBufremoveAllExceptCurrent<CR>", "Close all except current" },
				r = { "<cmd>lua require('spectre').open_file_search()<CR>", "Search and replace (file)" },
				R = { "<cmd>lua require('spectre').open()<CR>", "Search and replace (global)" },
				h = {
					name = "Harpoon",
					a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "add file mark " },
					m = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Quick menu" },
					n = { "<cmd>lua require('harpoon.ui').nav_next()<cr>", "next mark" },
					p = { "<cmd>lua require('harpoon.ui').nav_prev()<cr>", "prev mark" },
					t = {
						name = "Terminal",
						t = { "<cmd>lua require('harpoon.term').gotoTerminal(1)<cr>", "Terminal 1" },
						["1"] = { "<cmd>lua require('harpoon.term').gotoTerminal(1)<cr>", "Terminal 1" },
						["2"] = { "<cmd>lua require('harpoon.term').gotoTerminal(2)<cr>", "Terminal 2" },
						["3"] = { "<cmd>lua require('harpoon.term').gotoTerminal(3)<cr>", "Terminal 3" },
						["4"] = { "<cmd>lua require('harpoon.term').gotoTerminal(4)<cr>", "Terminal 4" },
					},
				},
				d = {
					name = "Debug",
					b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
					c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
					i = { "<cmd>lua require'dap'.step_into()<cr>", "Into" },
					o = { "<cmd>lua require'dap'.step_over()<cr>", "Over" },
					O = { "<cmd>lua require'dap'.step_out()<cr>", "Out" },
					r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Repl" },
					l = { "<cmd>lua require'osv'.run_this()<cr>", "Lua debug" },
					u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
					x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
				},
				E = { "<cmd>Dirbuf<cr>", "Dirbuf" },
				f = {
					name = "Find",
					d = {
						"<cmd>lua require('telescope').extensions.diff.diff_current({ hidden = true })<cr>",
						"Buffers",
					},
					D = {
						"<cmd>lua require('telescope').extensions.diff.diff_files({ hidden = true })<cr>",
						"Buffers",
					},
					b = { "<cmd>Telescope buffers<cr>", "Buffers" },
					B = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
					f = { "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>", "Find files" },
					w = { "<cmd>Telescope live_grep<cr>", "Find word" },
					-- f = { "<cmd>lua require('telescope').extensions.menufacture.find_files()<cr>", "Find files" },
					-- w = { "<cmd>lua require('telescope').extensions.menufacture.live_grep()<cr>", "Find word" },
					s = { "<cmd>Telescope lsp_document_symbols<cr>", "Find Symbols" },
					h = { "<cmd>Telescope help_tags<cr>", "Help" },
					r = { "<cmd>Telescope lsp_references<cr>", "References" },
					k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
					c = { "<cmd>Telescope commands<cr>", "Commands" },
					t = {
						name = "Tasks",
						s = { "<cmd>Telescope tasks specs<cr>", "Specs" },
						r = { "<cmd>Telescope tasks running<cr>", "Running" },
					},
					p = { "<cmd>Telescope projects<cr>", "Keymaps" },
				},
				g = {
					name = "Git",
					--g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
					j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
					k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
					l = { "<cmd>GitBlameToggle<cr>", "Blame" },
					p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
					r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
					R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
					s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
					u = {
						"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
						"Undo Stage Hunk",
					},
					o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
					b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
					c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
					d = {
						"<cmd>Gitsigns diffthis HEAD<cr>",
						"Diff",
					},
				},
				l = {
					name = "LSP",
					a = { "<cmd>Lspsaga code_action<CR>", "Code Action" },
					d = { "<cmd>Lspsaga show_line_diagnostics<CR>", "Diagnostics" },
					f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
					F = { "<cmd>Lspsaga lsp_finder<CR>", "Toggle Autoformat" },
					i = { "<cmd>LspInfo<cr>", "Info" },
					h = { "<cmd>IlluminationToggle<cr>", "Toggle Doc HL" },
					I = { "<cmd>Mason<cr>", "Installer Info" },
					v = { "<cmd>lua require('lsp_lines').toggle()<cr>", "Toggle Virtual Text" },
					l = {
						"<cmd>lua vim.diagnostic.config({ virtual_lines = { only_current_line = true } })<cr>",
						"Virtual Text current line",
					},
					o = { "<cmd>LSoutlineToggle<CR>" },
					r = { "<cmd>Lspsaga rename<CR>", "Rename" },
					R = { "<cmd>lua vim.lsp.buf.references()<cr>", "References" },
					s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
					S = {
						"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
						"Workspace Symbols",
					},
				},
				t = {
					name = "TypeScript",
					s = {
						"<cmd>lua require('vtsls').commands['restart_tsserver'](vim.api.nvim_get_current_buf(), function() end, function() end)<CR>",
						"restart tsserver",
					},
					l = {
						"<cmd>lua require('vtsls').commands['open_tsserver_log'](vim.api.nvim_get_current_buf(), function() end, function() end)<CR>",
						"open log",
					},
					v = {
						"<cmd>lua require('vtsls').commands['select_ts_version'](vim.api.nvim_get_current_buf(), function() end, function() end)<CR><cmd><CR>",
						"select ts version",
					},
					c = {
						"<cmd>lua require('vtsls').commands['goto_project_config'](vim.api.nvim_get_current_buf(), function() end, function() end)<CR><cmd><CR>",
						"go to project config",
					},
					d = {
						"<cmd>lua require('vtsls').commands['goto_source_definition'](vim.api.nvim_get_current_buf(), function() end, function() end)<CR><cmd><CR>",
						"source definition",
					},
					r = {
						"<cmd>lua require('vtsls').commands['rename_file'](vim.api.nvim_get_current_buf(), function() end, function() end)<CR><cmd><CR>",
						"rename file",
					},
					i = {
						name = "Imports",
						o = {
							"<cmd>lua require('vtsls').commands['organize_imports'](vim.api.nvim_get_current_buf(), function() end, function() end)<CR><cmd><CR>",
							"organize",
						},
						s = {
							"<cmd>lua require('vtsls').commands['sort_imports'](vim.api.nvim_get_current_buf(), function() end, function() end)<CR><cmd><CR>",
							"sort",
						},
						u = {
							"<cmd>lua require('vtsls').commands['remove_unused_imports'](vim.api.nvim_get_current_buf(), function() end, function() end)<CR><cmd><CR>",
							"remove unused imports",
						},
						a = {
							"<cmd>lua require('vtsls').commands['fix_all'](vim.api.nvim_get_current_buf(), function() end, function() end)<CR><cmd><CR>",
							"fix all",
						},
						r = {
							"<cmd>lua require('vtsls').commands['remove_unused'](vim.api.nvim_get_current_buf(), function() end, function() end)<CR><cmd><CR>",
							"remove unused",
						},
						m = {
							"<cmd>lua require('vtsls').commands['add_missing_imports'](vim.api.nvim_get_current_buf(), function() end, function() end)<CR><cmd><CR>",
							"add missing imports",
						},
					},
					a = { "<cmd><CR>", "source actions" },
				},
				P = {
					name = "Project",
					r = { "<cmd>IdeRecentProjects<cr>", "Recent" },
					w = { "<cmd>IdeProjectWrite<cr>", "Save" },
					s = { "<cmd>IdeProjectSettings<cr>", "Settings" },
					d = { "<cmd>IdeProjectDebug<cr>", "Debug" },
					l = { "<cmd>IdeProjectRun<cr>", "Launch" },
					c = { "<cmd>IdeProjectConfigure<cr>", "Config" },
				},
			}

			local vopts = {
				mode = "v", -- VISUAL mode
				prefix = "<leader>",
				buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
				silent = true, -- use `silent` when creating keymaps
				noremap = true, -- use `noremap` when creating keymaps
				nowait = true, -- use `nowait` when creating keymaps
			}
			local vmappings = {
				r = { "<ESC><cmd>lua require('spectre').open_file_search()<cr>", "Search and replace (file)" },
				R = { "<cmd>lua require('spectre').open_visual()<cr>", "Search and replace (global)" },
			}

			whichkey.setup(setup)
			whichkey.register(mappings, { prefix = "<leader>" })
			whichkey.register(vmappings, vopts)
		end,
	},
}
