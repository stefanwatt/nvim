return {
	"rcarriga/nvim-notify",
	config = function()
		require("notify").setup(
			{
				max_width=300,
				max_height=3,
				on_open = function()
				end,
				on_close = function()
				end,
				background_colour = "NotifyBackground",
				fps = 144,
				icons = {
					DEBUG = "",
					ERROR = "",
					INFO = "",
					TRACE = "✎",
					WARN = ""
				},
				level = 2,
				minimum_width = 50,
				render = "compact",
				stages = "fade_in_slide_out",
				time_formats = {
					notification = "%T",
					notification_history = "%FT%T"
				},
				timeout = 2000,
				top_down = true
			}
		)
	end
}

