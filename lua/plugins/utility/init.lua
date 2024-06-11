return {
	require("plugins.utility.tasks"),
	require("plugins.utility.notify"),
	require("plugins.utility.auto-session"),
	require("plugins.utility.persistence"),
	require("plugins.utility.copilot-chat"),
	require("plugins.utility.comment"),
	require("plugins.utility.diffview"),
	require("plugins.utility.surround"),
	require("plugins.utility.harpoon"),
	require("plugins.utility.mini-files"),
	{ "akinsho/toggleterm.nvim", version = "*", config = true },
}
