return {
	"rmagatti/auto-session",
	lazy = false,
	keys = {
		{
			"<C-p>",
			mode = { "n", "i", "v", "x" },
			function()
				require("auto-session.session-lens").search_session()
			end,
			desc = "Find session",
		},
	},
	config = function()
		require("auto-session").setup({
			log_level = "error",
			auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
			session_lens = {
				buftypes_to_ignore = {},
				load_on_setup = true,
				theme_conf = { border = true },
				previewer = false,
			},
		})
	end,
}
