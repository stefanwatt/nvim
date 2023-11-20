return {
	require("plugins.utility.tasks"),
	require("plugins.utility.bigfile"),
	require("plugins.utility.comment"),
	require("plugins.utility.surround"),
	require("plugins.utility.harpoon"),
	require("plugins.utility.mini-files"),
	require("plugins.utility.remote"),
	{ "akinsho/toggleterm.nvim", version = "*", config = true },
	{ "nvim-neo-tree/neo-tree.nvim", enabled = false },
}
