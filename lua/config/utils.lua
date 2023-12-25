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
	if not dir then
		return subdirectories
	end
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

local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

M.keymap = function(mode, lhs, rhs, extra_opts)
	local combined_opts = vim.tbl_extend("force", opts, extra_opts or {})
	keymap(mode, lhs, rhs, combined_opts)
end

M.buf_vtext = function()
	local a_orig = vim.fn.getreg("a")
	local mode = vim.fn.mode()
	if mode ~= "v" and mode ~= "V" then
		vim.cmd([[normal! gv]])
	end
	vim.cmd([[silent! normal! "aygv]])
	local text = vim.fn.getreg("a")
	vim.fn.setreg("a", a_orig)
	return tostring(text)
end

M.get_visual_selection = function()
	vim.fn.setpos("'<", vim.fn.getpos("'<"))
	vim.fn.setpos("'>", vim.fn.getpos("'>"))
	local start_pos = vim.fn.getpos("'<") -- Get the start position of the visual selection
	local end_pos = vim.fn.getpos("'>") -- Get the end position of the visual selection
	if not start_pos or not end_pos then
		return nil
	end
	local lines = vim.fn.getline(start_pos[2], end_pos[2]) -- Get the lines within the visual selection
	if type(lines) == "string" then
		local start_col = start_pos[3] - 1 -- Convert to 0-based indexing
		local end_col = end_pos[3] - 1

		-- Check for valid column values
		if not start_col or not end_col then
			return nil
		end

		return lines:sub(start_col + 1, end_col + 1)
	end

	if not lines then
		return nil
	end

	if #lines == 1 then
		local start_col = start_pos[3] - 1 -- Convert to 0-based indexing
		local end_col = end_pos[3] - 1
		return lines[1]:sub(start_col + 1, end_col + 1)
	else
		local result = {}
		for i, line in ipairs(lines) do
			if i == 1 then
				local start_col = start_pos[3] - 1 -- Convert to 0-based indexing
				result[#result + 1] = line:sub(start_col + 1)
			elseif i == #lines then
				local end_col = end_pos[3] - 1
				result[#result + 1] = line:sub(1, end_col + 1)
			else
				result[#result + 1] = line
			end
		end
		return table.concat(result, "\n")
	end
end

return M
