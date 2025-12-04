return {
	"neomerge",
	name = "neomerge",
	dir = "/home/stefan/Projects/neomerge",
	lazy = false,
	config = function()
		require("neomerge").setup({
			keymaps = {
				accept_local = "<leader>ml",
				accept_remote = "<leader>mr",
				accept_current = "<leader>mc",
				next_conflict = "]c",
				prev_conflict = "[c",
				auto_select_all = "<leader>ma",
				auto_select_local = "<leader>mL",
				auto_select_remote = "<leader>mR",
				finish_merge = "<leader>mf",
			},
		})
	end,
}
