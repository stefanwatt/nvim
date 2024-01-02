local utils = require("config.search-and-replace.builtin.utils")
local movement = require("config.search-and-replace.builtin.movement")
local M = {}

local keymap_set = false

local function move_to_next_pos()
	local cursor = utils.cursor_pos_in_subst_cmd()
	if cursor == "search" then
		movement.from_search_to_replace()
	elseif cursor == "replace" then
		movement.from_replace_to_end()
	end
end

local function move_to_prev_pos()
	local cursor = utils.cursor_pos_in_subst_cmd()
	if cursor == "end" then
		movement.from_end_to_replace()
	elseif cursor == "replace" then
		movement.from_replace_to_search()
	end
end

local function setup_keymaps()
	print("setup keymaps")
	vim.keymap.set("c", "<Tab>", function()
		if utils.is_substitute_command() then
			move_to_next_pos()
		else
			print("not substitute cmd")
			vim.api.nvim_feedkeys("<Tab>", "n", true)
		end
	end, { noremap = true })
	vim.keymap.set("c", "<S-Tab>", function()
		if utils.is_substitute_command() then
			move_to_prev_pos()
		else
			print("not substitute cmd")
			vim.api.nvim_feedkeys("<S-Tab>", "n", true)
		end
	end, { noremap = true })
end

---@param opts table{visual:boolean}
M.search_and_replace = function(opts)
	if not keymap_set then
		setup_keymaps()
	end
	local selection = opts.visual and utils.buf_vtext() or ""
	local cmd_string = ":%s/" .. selection .. "//gc<Left><Left><Left>"
	if selection == "" then
		cmd_string = cmd_string .. "<Left>"
	end
	if opts.visual then
		cmd_string = "<Esc>" .. cmd_string
	end
	cmd_string = vim.api.nvim_replace_termcodes(cmd_string, true, false, true)
	vim.api.nvim_feedkeys(cmd_string, "n", true)
end

return M
