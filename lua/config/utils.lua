local M = {}

M.MoveBufferToOppositeWindow = function()
	local current_buffer = vim.api.nvim_get_current_buf()
	local current_window = vim.api.nvim_get_current_win()
	local target_window = nil

	for _, win in pairs(vim.api.nvim_list_wins()) do
		if win ~= current_window then
			if vim.bo.buftype == "" then
				target_window = win
				break
			end
		end
	end

	if target_window then
		MiniBufremove.delete()
		vim.api.nvim_set_current_win(target_window)
		vim.api.nvim_set_current_buf(current_buffer)
	end
end

M.getSubDirectories = function(dirname)
	local dir = io.popen("ls " .. dirname)
	local subdirectories = {}
	for name in dir:lines() do
		table.insert(subdirectories, name)
	end
	return subdirectories
end

M.get_buf_text = function()
	local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
	return table.concat(content, "\n")
end

M.icons = {
	Vim = "",
	Config = "",
	Normal = "󰁁",
	Insert = "󰌌",
	Terminal = "",
	Visual = "󰉸",
	Command = "",
	Save = "󰳻",
	NotSaved = "󱙃",
	Restore = "󰁯",
	Trash = "",
	Fedora = "",
	Lua = "",
	Github = "",
	Git = "󰊢",
	GitDiff = "",
	GitBranch = "",
	GitCommit = "",
	Add = "",
	Change = "",
	Delete = "",
	Hint = "󰌶",
	Error = "󰅚",
	Info = "󰋽",
	Warn = "",
	Package = "󰏖",
	FileTree = "󰙅",
	Folder = "",
	EmptyFolder = "",
	FolderClock = "󰪻",
	File = "",
	NewFile = "",
	DefaultFile = "󰈙",
	Color = "",
	ColorPicker = "󰴱",
	ColorOn = "󰌁",
	ColorOff = "󰹊",
	Swap = "󰓡",
	Minimap = "",
	Window = "",
	Windows = "",
	Ellipsis = "…",
	Search = "",
	TextSearch = "󱩾",
	TabSearch = "󱦞",
	FileSearch = "󰱼",
	Clear = "",
	Braces = "󰅩",
	Exit = "󰗼",
	Debugger = "",
	Breakpoint = "",
	History = "",
	Check = "󰄵",
	SmallDot = "󰧞",
	Dots = "󰇘",
	Install = "",
	Help = "󰋖",
	Clipboard = "󰅌",
	Indent = "",
	LineWrap = "󰖶",
	Comment = "󱋄",
	Close = "󰅘",
	Open = "󰏋",
	Toggle = "󰔡",
	Stop = "",
	Restart = "",
	CloseMultiple = "󰱞",
	NextBuffer = "󰮱,",
	PrevBuffer = "󰮳",
	FoldClose = "",
	FoldOpen = "",
	Popup = "󰕛",
	Vertical = "",
	Horizontal = "",
	Markdown = "󰽛",
	Up = "",
	Down = "",
	Left = "",
	Right = "",
	Variable = "",
	Stack = "",
	Format = "󰉣",
	Edit = "󰤌",
	Fix = "",
	Run = "󰐍",
	Twilight = "󰖚",
	Recording = "󰑋",
	Notification = "󰍢",
	NotificationDismiss = "󱙍",
	NotificationLog = "󰍩",
	Code = "",
	DropDown = "󰁊",
	Web = "󰖟",
	Dependencies = "",
	Update = "󰚰",
	Database = "",
	Pin = "",
	Book = "󰂽",
	BookmarkSearch = "󰺄",
	Download = "󰇚",
}

M.format = function(icon, text)
	return M.icons[icon] .. " " .. text
end

return M
