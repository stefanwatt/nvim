return {
	require("plugins.utility.tasks"),
	require("plugins.utility.notify"),
	require("plugins.utility.persistence"),
	require("plugins.utility.smart-splits"),
	require("plugins.utility.copilot-chat"),
	require("plugins.utility.bigfile"),
	require("plugins.utility.comment"),
	require("plugins.utility.surround"),
	require("plugins.utility.harpoon"),
	require("plugins.utility.mini-files"),
	{ "akinsho/toggleterm.nvim", version = "*", config = true },
	{ "nvim-neo-tree/neo-tree.nvim", enabled = false },
}
