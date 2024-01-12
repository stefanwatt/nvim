local format_icons = require("config.utils").format_icons

return {
	{
		"luckasRanarison/clear-action.nvim",
		event = "VeryLazy",
		opts = {
			signs = {
				show_count = false,
				show_label = true,
				combine = true,
			},
			mappings = {
				quickfix = { "<leader>aq", format_icons("Fix", "Quickfix") },
				quickfix_next = { "<leader>an", format_icons("Fix", "Quickfix next") },
				quickfix_prev = { "<leader>ap", format_icons("Fix", "Quickfix prev") },
				refactor = { "<leader>ar", format_icons("Fix", "Refactor") },
				refactor_inline = { "<leader>aR", format_icons("Fix", "Refactor inline") },
				actions = {
					["tsserver"] = {
						["OrganizeImports"] = { "<leader>at", format_icons("Fix", "Organize Imports") },
					},
					["rust_analyzer"] = {
						["Import"] = { "<leader>ai", format_icons("Fix", "Import") },
						["Replace if"] = { "<leader>am", format_icons("Fix", "Replace if with match") },
						["Fill match"] = { "<leader>af", format_icons("Fix", "Fill match arms") },
						["Wrap"] = { "<leader>aw", format_icons("Fix", "Wrap") },
						["Insert `mod"] = { "<leader>aM", format_icons("Fix", "Insert mod") },
						["Insert `pub"] = { "<leader>aP", format_icons("Fix", "Insert pub mod") },
						["Add braces"] = { "<leader>ab", format_icons("Fix", "Add braces") },
					},
				},
			},
			quickfix_filters = {
				["rust_analyzer"] = {
					["E0412"] = "Import",
					["E0425"] = "Import",
					["E0433"] = "Import",
					["unused_imports"] = "remove",
				},
			},
		},
	},
}
