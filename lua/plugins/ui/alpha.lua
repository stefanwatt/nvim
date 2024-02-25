return {
	{
		lazy = false,
		"goolord/alpha-nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-web-devicons" },
		keys = {
			{
				"<leader>D",
				mode = { "n" },
				"<cmd>Alpha<cr>",
				desc = "Dashboard",
			},
		},
		config = function()
			local alpha = require("alpha")
			local plenary_path = require("plenary.path")
			local isometric = {
				[[      ___          ___          ___                                 ___     ]],
				[[     /__/\        /  /\        /  /\         ___       ___         /__/\    ]],
				[[     \  \:\      /  /:/_      /  /::\       /__/\     /  /\       |  |::\   ]],
				[[      \  \:\    /  /:/ /\    /  /:/\:\      \  \:\   /  /:/       |  |:|:\  ]],
				[[  _____\__\:\  /  /:/ /:/_  /  /:/  \:\      \  \:\ /__/::\     __|__|:|\:\ ]],
				[[ /__/::::::::\/__/:/ /:/ /\/__/:/ \__\:\ ___  \__\:\\__\/\:\__ /__/::::| \:\]],
				[[ \  \:\~~\~~\/\  \:\/:/ /:/\  \:\ /  /://__/\ |  |:|   \  \:\/\\  \:\~~\__\/]],
				[[  \  \:\  ~~~  \  \::/ /:/  \  \:\  /:/ \  \:\|  |:|    \__\::/ \  \:\      ]],
				[[   \  \:\       \  \:\/:/    \  \:\/:/   \  \:\__|:|    /__/:/   \  \:\     ]],
				[[    \  \:\       \  \::/      \  \::/     \__\::::/     \__\/     \  \:\    ]],
				[[     \__\/        \__\/        \__\/          ~~~~                 \__\/    ]],
			}
			local slanted = {
				[[                                                                   ]],
				[[      ████ ██████           █████      ██                    ]],
				[[     ███████████             █████                            ]],
				[[     █████████ ███████████████████ ███   ███████████  ]],
				[[    █████████  ███    █████████████ █████ ██████████████  ]],
				[[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
				[[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
				[[██████  █████████████████████ ████ █████ █████ ████ ██████]],
			}
			local neovim = {
				[[                                           ██             ]],
				[[                                           ▀▀             ]],
				[[██▄████▄   ▄████▄    ▄████▄   ██▄  ▄██   ████     ████▄██▄]],
				[[██▀   ██  ██▄▄▄▄██  ██▀  ▀██   ██  ██      ██     ██ ██ ██]],
				[[██    ██  ██▀▀▀▀▀▀  ██    ██   ▀█▄▄█▀      ██     ██ ██ ██]],
				[[██    ██  ▀██▄▄▄▄█  ▀██▄▄██▀    ████    ▄▄▄██▄▄▄  ██ ██ ██]],
				[[▀▀    ▀▀    ▀▀▀▀▀     ▀▀▀▀       ▀▀     ▀▀▀▀▀▀▀▀  ▀▀ ▀▀ ▀▀]],
			}

			local bloody = {
				[[ ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓]],
				[[ ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒]],
				[[▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░]],
				[[▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ ]],
				[[▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒]],
				[[░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░]],
				[[░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░]],
				[[   ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░   ]],
				[[         ░    ░  ░    ░ ░        ░   ░         ░   ]],
				[[                                ░                  ]],
			}
			local header = {
				type = "text",
				val = bloody,
				opts = {
					position = "center",
					hl = "Type",
					-- wrap = "overflow";
				},
			}
			local startify = require("alpha.themes.startify")
			local dashboard = require("alpha.themes.dashboard")
			local button = dashboard.button

			local nvim_web_devicons = {
				enabled = true,
				highlight = true,
			}
			local function get_extension(fn)
				local match = fn:match("^.+(%..+)$")
				local ext = ""
				if match ~= nil then
					ext = match:sub(2)
				end
				return ext
			end

			local function icon(fn)
				local nwd = require("nvim-web-devicons")
				local ext = get_extension(fn)
				return nwd.get_icon(fn, ext, { default = true })
			end

			local function file_button(fn, sc, short_fn, autocd)
				short_fn = short_fn or fn
				local ico_txt
				local fb_hl = {}

				if nvim_web_devicons.enabled then
					local ico, hl = icon(fn)
					local hl_option_type = type(nvim_web_devicons.highlight)
					if hl_option_type == "boolean" then
						if hl and nvim_web_devicons.highlight then
							table.insert(fb_hl, { hl, 0, 3 })
						end
					end
					if hl_option_type == "string" then
						table.insert(fb_hl, { nvim_web_devicons.highlight, 0, 3 })
					end
					ico_txt = ico .. "  "
				else
					ico_txt = ""
				end
				local cd_cmd = (autocd and " | cd %:p:h" or "")
				local file_button_el = dashboard.button(sc, ico_txt .. short_fn, "<cmd>e " .. fn .. cd_cmd .. " <CR>")
				local fn_start = short_fn:match(".*[/\\]")
				if fn_start ~= nil then
					table.insert(fb_hl, { "Comment", #ico_txt - 2, #fn_start + #ico_txt })
				end
				file_button_el.opts.hl = fb_hl
				return file_button_el
			end

			local paths = require("config.paths")
			local favorites = {
				type = "group",
				val = {
					file_button(paths.wm_config, "w", "wm config"),
					file_button("~/.config/nixos/flake.nix", "x", "nixos config"),
					file_button("~/.config/nvim/init.lua", "n", "nvim config"),
					button("p", "  projects", ":Telescope projects<CR>"),
				},
				position = "center",
			}
			local top_buttons = {
				type = "group",
				val = {
					button("e", "  New file", ":ene <BAR> startinsert <CR>"),
					button("l", "🖫  Restore last session", ":lua require('persistence').load({last=true})<CR>"),
				},
				position = "center",
			}
			local bottom_buttons = {
				type = "group",
				val = {
					button("q", "  Quit NVIM", ":qa<CR>"),
				},
				position = "center",
			}
			local projectDirectories = require("config.utils").getSubDirectories("~/Projects/")
			local projectEntriesStart = 11
			local projectEntries = {}
			for i, dirname in ipairs(projectDirectories) do
				projectEntries[i] =
					file_button("~/Projects/" .. dirname, tostring(i + projectEntriesStart - 1), dirname)
			end

			local projects = {
				type = "group",
				val = function()
					return projectEntries
				end,
			}
			local if_nil = vim.F.if_nil
			local default_mru_ignore = { "gitcommit" }
			local mru_opts = {
				ignore = function(path, ext)
					return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
				end,
				autocd = false,
			}
			local function mru(start, cwd, items_number, opts)
				opts = opts or mru_opts
				items_number = if_nil(items_number, 10)

				local oldfiles = {}
				for _, v in pairs(vim.v.oldfiles) do
					if #oldfiles == items_number then
						break
					end
					local cwd_cond
					if not cwd then
						cwd_cond = true
					else
						cwd_cond = vim.startswith(v, cwd)
					end
					local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
					if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
						oldfiles[#oldfiles + 1] = v
					end
				end
				local target_width = 35

				local tbl = {}
				for i, fn in ipairs(oldfiles) do
					local short_fn
					if cwd then
						short_fn = vim.fn.fnamemodify(fn, ":.")
					else
						short_fn = vim.fn.fnamemodify(fn, ":~")
					end

					if #short_fn > target_width then
						short_fn = plenary_path.new(short_fn):shorten(1, { -2, -1 })
						if #short_fn > target_width then
							short_fn = plenary_path.new(short_fn):shorten(1, { -1 })
						end
					end

					local shortcut = tostring(i + start - 1)

					local file_button_el = file_button(fn, shortcut, short_fn, opts.autocd)
					tbl[i] = file_button_el
				end
				return {
					type = "group",
					val = tbl,
					opts = {},
				}
			end

			local cdir = vim.fn.getcwd()
			local section_mru = {
				type = "group",
				val = {
					{
						type = "text",
						val = "Recent files",
						opts = {
							hl = "SpecialComment",
							shrink_margin = false,
							position = "center",
						},
					},
					{ type = "padding", val = 1 },
					{
						type = "group",
						val = function()
							return { mru(1, cdir) }
						end,
						opts = { shrink_margin = false },
					},
				},
			}

			local section = startify.section
			local footer = {
				type = "text",
				val = "https://github.com/stefanwatt/nvim",
				opts = {
					position = "center",
					hl = "Number",
				},
			}
			local config = {
				layout = {
					{ type = "padding", val = 5 },
					header,
					{ type = "padding", val = 2 },
					{
						type = "text",
						val = "Quick Links",
						opts = { hl = "SpecialComment", shrink_margin = false, position = "center" },
					},
					top_buttons,
					favorites,
					{ type = "padding", val = 1 },
					section_mru,
					-- { type = "padding", val = 1 },
					-- { type = "text", val = "Projects", opts = { hl = "SpecialComment", shrink_margin = false, position = "center" } },
					-- { type = "padding", val = 1 },
					-- projects,
					{ type = "padding", val = 1 },
					bottom_buttons,
					{ type = "padding", val = 5 },
					footer,
				},
				opts = {
					margin = 5,
					setup = function()
						vim.api.nvim_create_autocmd("DirChanged", {
							pattern = "*",
							callback = function()
								require("alpha").redraw()
							end,
						})
					end,
				},
			}
			alpha.setup(config)
		end,
	},
}
