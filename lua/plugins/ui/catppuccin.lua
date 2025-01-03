return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		flavour = "frappe",
		styles = {
			comments = {},
		},
		integrations = {
			alpha = true,
			cmp = true,
			gitsigns = true,
			illuminate = true,
			indent_blankline = { enabled = true },
			lsp_trouble = true,
			mason = true,
			mini = true,
			native_lsp = {
				enabled = true,
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			-- navic = { enabled = false, custom_bg = "lualine" },
			neotest = true,
			noice = true,
			notify = true,
			neotree = true,
			semantic_tokens = true,
			telescope = true,
			treesitter = true,
			which_key = true,
		},
	},
	config = function()
		require("catppuccin").setup({
			color_overrides = {
				frappe = {
					base = "#272a38",
				},
			},
			custom_highlights = function(colors)
				return {
					LspInlayHint = { bg = "NONE", fg = colors.overlay1, italic = true },
				}
			end,
		})
		vim.cmd.colorscheme("catppuccin-frappe")
		local colors = require("catppuccin.palettes").get_palette()
		vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", {
			fg = colors.overlay0,
		})

		vim.api.nvim_set_hl(0, "BlinkCmpMenu", { fg = colors.text })
		vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = colors.blue })
		vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = colors.surface0 })
	end,
}
