return {
	require("plugins.utility.tasks"),
	require("plugins.utility.ranger"),
	require("plugins.utility.comment"),
	require("plugins.utility.surround"),
	require("plugins.utility.harpoon"),
	require("plugins.utility.mini-files"),
	{ "akinsho/toggleterm.nvim", version = "*", config = true },
}