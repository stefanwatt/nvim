local function getScriptsFromPackageJson()
	local packageJson = vim.fn.glob("package.json")
	if packageJson == "" then
		return {}
	end
	local packageJsonContent = vim.fn.readfile(packageJson)
	local packageJsonString = table.concat(packageJsonContent, "\n")
	local packageJsonTable = vim.fn.json_decode(packageJsonString)
	local scripts = packageJsonTable.scripts
	local items = {}
	for scriptName, _ in pairs(scripts) do
		table.insert(items, { text = scriptName, cmd = { "npm", "run", scriptName } })
	end
	return items
end

---@return table{ text: string, file: string }
local function get_help_tags()
	local help_tags = {}
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
	return help_tags
end

return {
	{
		"echasnovski/mini.pick",
		version = false,
		event = "VeryLazy",
		config = function()
			require("mini.pick").setup({
				delay = {
					async = 10,
					busy = 50,
				},
				mappings = {
					caret_left = "<Left>",
					caret_right = "<Right>",
					choose = "<CR>",
					choose_in_split = "<C-o>",
					choose_in_tabpage = "<C-t>",
					choose_in_vsplit = "<C-v>",
					choose_marked = "<C-s>",
					delete_char = "<BS>",
					delete_char_right = "<Del>",
					delete_left = "<C-u>",
					delete_word = "<C-w>",
					mark = "<C-x>",
					mark_all = "<C-a>",
					move_down = "<C-n>",
					move_start = "<C-g>",
					move_up = "<C-p>",
					paste = "<C-r>",
					refine = "<C-Space>",
					refine_marked = "<M-Space>",
					scroll_down = "<C-f>",
					scroll_left = "<C-h>",
					scroll_right = "<C-l>",
					scroll_up = "<C-b>",
					stop = "<Esc>",
					toggle_info = "<S-Tab>",
					toggle_preview = "<Tab>",
				},
				options = {
					content_from_bottom = false,
					use_cache = false,
				},
				source = {
					items = nil,
					name = nil,
					cwd = nil,
					match = nil,
					show = nil,
					preview = nil,
					choose = nil,
					choose_marked = nil,
				},
				window = {
					config = nil,
				},
			})
		end,
		keys = {
			{
				"<leader>fb",
				mode = { "n" },
				"<cmd>lua MiniPick.builtin.buffers()<cr>",
				desc = "Buffers",
			},
			{
				"<leader>ff",
				mode = { "n" },
				"<cmd>lua MiniPick.builtin.files()<cr>",
				desc = "Find files",
			},
			{
				"<leader>fw",
				mode = { "n" },
				"<cmd>lua MiniPick.builtin.grep_live()<cr>",
				desc = "Find word",
			},

			{
				"<leader>fh",
				mode = { "n" },
				function()
					MiniPick.start({
						source = {
							name = "Help",
							items = get_help_tags(),
							choose = function(item)
								if not item then
									return
								end
								local windows = vim.api.nvim_list_wins()
								local utils = require("config.utils")
								local current_help_windows = utils.filter(windows, utils.is_help_window)
								vim.api.nvim_command("help " .. item.text)
								windows = vim.api.nvim_list_wins()
								local new_help_windows = utils.filter(windows, function(win)
									return utils.is_help_window(win) and not vim.tbl_contains(current_help_windows, win)
								end)
								local focused_win = new_help_windows[1]
								if #new_help_windows == 0 then
									focused_win = utils.find(current_help_windows, function(win)
										local filepath_without_last_dir = item.file:gsub("/[^/]+$", "")
										local buf_of_win = vim.api.nvim_win_get_buf(win)
										local bufname = vim.api.nvim_buf_get_name(buf_of_win)
										return bufname:find(filepath_without_last_dir, 1, true)
									end)
								end
								if not focused_win then
									return
								end
								vim.schedule(function()
									vim.api.nvim_set_current_win(focused_win)
								end)
							end,
						},
					})
				end,
				desc = "Find help",
			},
			{
				"<leader>ftx",
				mode = { "n" },
				function()
					MiniPick.start({
						source = {
							name = "Tasks",
							items = getScriptsFromPackageJson(),
							choose = function(item)
								vim.cmd("vsplit")
								local win = vim.api.nvim_get_current_win()
								local buf = vim.api.nvim_create_buf(true, true)
								vim.api.nvim_win_set_buf(win, buf)
								vim.fn.jobstart(item.cmd, {
									on_stdout = function(_, data)
										if data then
											local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
											vim.list_extend(lines, data)
											vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
										end
									end,
									on_stderr = function(_, data)
										print(vim.inspect(data))
									end,
								})
							end,
						},
					})
				end,
				desc = "Find word",
			},
		},
	},
}
