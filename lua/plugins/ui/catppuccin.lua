local function blend_colors(color1, color2, ratio)
    ratio = ratio / 100.0
    local r1 = tonumber(color1:sub(2,3), 16)
    local g1 = tonumber(color1:sub(4,5), 16)
    local b1 = tonumber(color1:sub(6,7), 16)
    local r2 = tonumber(color2:sub(2,3), 16)
    local g2 = tonumber(color2:sub(4,5), 16)
    local b2 = tonumber(color2:sub(6,7), 16)

    local r = math.floor(r1 * ratio + r2 * (1 - ratio))
    local g = math.floor(g1 * ratio + g2 * (1 - ratio))
    local b = math.floor(b1 * ratio + b2 * (1 - ratio))

    return string.format("#%02x%02x%02x", r, g, b)
end
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


		vim.api.nvim_set_hl(0, "DiffText", { bg = colors.yellow, fg= colors.crust })
		vim.api.nvim_set_hl(0, "DiffChange", { bg = blend_colors(colors.yellow, colors.base, 40), fg= colors.text })
	end,
}
