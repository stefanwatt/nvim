local M = {}

---@return string
M.get_help_tags = function()
	local help_tags = {}
	local result = ""
	for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
		local tags_file = path .. "/doc/tags"
		local file = io.open(tags_file, "r")
		if file then
			for line in file:lines() do
				local tag = line:match("^(.-)\t")
				if tag then
					table.insert(help_tags, { text = tag, file = tags_file })
				end
			end
			file:close()
		end
	end
	return vim.inspect(help_tags)
end

---@param command string
M.NvimFloat = function(command)
	local cwd = vim.fn.getcwd()
	local servername = vim.v.servername
	os.execute(
		"/home/stefan/Projects/nvim-float/nvim-float"
			.. " --servername "
			.. '"'
			.. servername
			.. '"'
			.. " --dir "
			.. cwd
			.. " "
			.. command
			.. "&"
	)
end

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

M.merge_tables = function(...)
	local tables = { ... }
	local result = {}

	for _, tbl in ipairs(tables) do
		if type(tbl) == "table" then
			for key, value in pairs(tbl) do
				result[key] = value
			end
		end
	end

	return result
end

---@param table table
---@param cb function(value: any): boolean
M.index_of = function(table, cb)
	for index, value in ipairs(table) do
		if cb(value) then
			return index
		end
	end
	return nil
end

---@param list table
---@param cb function(value: any): boolean
M.filter = function(list, cb)
	local result = {}
	for _, value in ipairs(list) do
		if cb(value) then
			table.insert(result, value)
		end
	end
	return result
end

---@generic T
---@param list `T`[]
---@param cb function(value: `T`): `T`
---@return `T` | nil
M.find = function(list, cb)
	for _, value in ipairs(list) do
		if cb(value) then
			return value
		end
	end
	return nil
end

---@generic T
---@param list Array<`T`>
---@param cb function(value: `T`): `T`
M.map = function(list, cb)
	local result = {}
	for _, value in ipairs(list) do
		table.insert(result, cb(value))
	end
	return result
end

---@param win number
M.is_help_window = function(win)
	return vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "buftype") == "help"
end

---@param buffer number
M.get_window_of_buffer = function(buffer)
	local windows = vim.api.nvim_list_wins() -- List all windows

	for _, win in ipairs(windows) do
		if vim.api.nvim_win_get_buf(win) == buffer then
			return win
		end
	end
end

---@param cb function
M.debounce = function(cb, delay, ...)
	local timer_id = nil
	return function(...)
		if timer_id ~= nil then
			vim.fn.timer_stop(timer_id)
		end
		local args = { ... }
		timer_id = vim.fn.timer_start(delay, function()
			-- cb(unpack(args))
			cb()
		end)
	end
end

M.cmp_icons = {
	misc = {
		dots = "󰇘",
	},
	dap = {
		Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
		Breakpoint = " ",
		BreakpointCondition = " ",
		BreakpointRejected = { " ", "DiagnosticError" },
		LogPoint = ".>",
	},
	diagnostics = {
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	},
	git = {
		added = " ",
		modified = " ",
		removed = " ",
	},
	kinds = {
		Array = " ",
		Boolean = "󰨙 ",
		Class = " ",
		Codeium = "󰘦 ",
		Color = " ",
		Control = " ",
		Collapsed = " ",
		Constant = "󰏿 ",
		Constructor = " ",
		Copilot = " ",
		Enum = " ",
		EnumMember = " ",
		Event = " ",
		Field = " ",
		File = " ",
		Folder = " ",
		Function = "󰊕 ",
		Interface = " ",
		Key = " ",
		Keyword = " ",
		Method = "󰊕 ",
		Module = " ",
		Namespace = "󰦮 ",
		Null = " ",
		Number = "󰎠 ",
		Object = " ",
		Operator = " ",
		Package = " ",
		Property = " ",
		Reference = " ",
		Snippet = " ",
		String = " ",
		Struct = "󰆼 ",
		TabNine = "󰏚 ",
		Text = " ",
		TypeParameter = " ",
		Unit = " ",
		Value = " ",
		Variable = "󰀫 ",
	},
}
return M
