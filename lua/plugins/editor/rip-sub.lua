return {
	-- "chrisgrieser/nvim-rip-substitute",
	"rip-substitute",
	enabled =false,
	name = "nvim-rip-substitute",
	dir = "/home/stefan/Projects/nvim-rip-substitute",
	keys = {
		{
			"<C-h>",
			function()
				require("rip-substitute").sub()
			end,
			mode = { "n", "x" },
			desc = " rip sub",
		},
	},
	event = "VeryLazy",
	config = function()
		require("rip-substitute").setup({
			popupWin = {
				position = "top",
			},
			prefill = {
				normal = false,             -- "cursorWord"|false
				visual = "selectionFirstLine", -- "selectionFirstLine"|false
				startInReplaceLineIfPrefill = true,
			},
		})
	end,
}
