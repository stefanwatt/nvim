local M = {}

---@param name string
local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

---@return string[]
M.get_buf_lines = function()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local result = {}
	for i, line in ipairs(lines) do
		local buf = vim.api.nvim_get_current_buf()
		local signs = vim.fn.sign_getplaced(buf, { lnum = i })[1].signs
		if not signs or #signs == 0 then
			table.insert(result, { sign = "", row = i, line = line })
		else
			local sign = signs[1].name
			table.insert(result, { sign = sign, row = i, line = line })
		end
	end
	return result
end

---@param channel number
M.listen_for_mode_change = function(channel)
	local event_name = "nvim-gui-mode-changed"
	vim.api.nvim_create_autocmd("ModeChanged", {
		group = augroup(event_name),
		pattern = "*",
		callback = function()
			local new_mode = vim.fn.mode()
			vim.fn.rpcrequest(channel, event_name, {
				new_mode,
			})
		end,
	})
	return "success"
end

---@param channel number
M.listen_for_visual_selection_change = function(channel)
	local event_name = "nvim-gui-visual-selection-changed"
	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "ModeChanged" }, {
		group = augroup(event_name),
		pattern = "*",
		callback = function()
			local mode = vim.fn.mode()
			if mode == "v" or mode == "V" then
				local _, start_row, start_col, _ = unpack(vim.fn.getpos("v"))
				local _, end_row, end_col, _ = unpack(vim.fn.getpos("."))
				vim.fn.rpcrequest(channel, event_name, {
					start_row = math.max(start_row - 1, 0),
					start_col = math.max(start_col - 1, 0),
					end_row = math.max(end_row - 1, 0),
					end_col = math.max(end_col - 1, 0),
				})
			end
		end,
	})
	return "success"
end

---@param channel number
M.listen_for_cursor_move = function(channel)
	local event_name = "nvim-gui-cursor-moved"
	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		group = augroup(event_name),
		callback = function(event)
			local cursor = vim.api.nvim_win_get_cursor(0)
			local row = cursor[1]
			local col = cursor[2]
			local key_at_cursor = vim.fn.getline(row):sub(col + 1, col + 1)
			local top_line = vim.fn.line("w0")
			local bottom_line = vim.fn.line("w$")
			vim.fn.rpcrequest(channel, event_name, {
				row = row - 1,
				col = col,
				key = key_at_cursor,
				top_line = top_line,
				bottom_line = bottom_line,
			})
		end,
	})
	return "success"
end

---@param channel number
M.attach_buffer = function(channel)
	vim.api.nvim_buf_attach(0, false, {
		on_lines = function(...)
			vim.fn.rpcrequest(channel, "nvim-gui-current-buf-changed", { ... })
		end,
	})
	return "success"
end

M.get_buffer = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local buffer = {}

	for i, line in ipairs(lines) do
		local hl_groups = get_hl_groups(bufnr, i)
		table.insert(buffer, { line = line, row = i, hl_groups = hl_groups })
	end

	return buffer
end

M.decimal_to_hex_color = function(decimal)
	return string.format("#%06x", decimal)
end

---@alias HighlightIterator fun(end_line: integer?): integer, TSNode, vim.treesitter.query.TSMetadata, TSQueryMatch, table

---@param bufnr number
---@param start_row number
---@param end_row number
---@return HighlightIterator|nil, table
local function get_hl_captures(bufnr, start_row, end_row)
	local highlighter = vim.treesitter.highlighter
	local parsers = require("nvim-treesitter.parsers")
	local ts_utils = require("nvim-treesitter.ts_utils")

	local parser = parsers.get_parser(bufnr)
	if not parser then
		return nil, {}
	end

	local tree = parser:parse()[1]
	if not tree then
		return nil, {}
	end

	local root = tree:root()
	if not root then
		return nil, {}
	end

	local query = vim.treesitter.query.get(parser:lang(), "highlights")
	if not query then
		return nil, {}
	end
	return query:iter_captures(root, bufnr, start_row, end_row), query.captures
end

---@param start_row number
---@param start_col number
---@param end_row number
---@param end_col number
M.get_tokens = function(start_row, start_col, end_row, end_col)
	local bufnr = vim.api.nvim_get_current_buf()
	local iterator, captures = get_hl_captures(bufnr, start_row, end_row)
	if not iterator or captures == {} then
		return nil
	end

	local tokens = {}
	local seen = {}
	for id, node, _ in iterator do
		local node_start_row, node_start_col, node_end_row, node_end_col = node:range()
		if
			(end_row == node_start_row and node_start_col >= end_col)
			or (start_row == node_end_row and node_end_col <= start_col)
		then
			goto continue
		end
		local token = {
			start_row = node_start_row,
			start_col = node_start_col,
			end_row = node_end_row,
			end_col = node_end_col,
		}
		local capture_name = captures[id]
		local key = tostring(node_start_row)
			.. "-"
			.. tostring(node_start_col)
			.. "-"
			.. tostring(node_end_row)
			.. "-"
			.. tostring(node_end_col)
		-- if capture_name ~= "comment.documentation" and seen[key] then
		-- 	goto continue
		-- end
		seen[key] = true
		local ok, text =
			pcall(vim.api.nvim_buf_get_text, bufnr, node_start_row, node_start_col, node_end_row, node_end_col, {})
		token.text = ok and text[1] or ""
		if capture_name ~= "string" and capture_name ~= "comment.documentation" and node:child_count() ~= 0 then
			goto continue
		end
		if capture_name then
			token.hl_group = capture_name
			local ok, highlights = pcall(vim.api.nvim_get_hl_by_name, "@" .. capture_name, true)
			if not ok then
				ok, highlights = pcall(vim.api.nvim_get_hl_by_name, capture_name, true)
			end
			for k, v in pairs(highlights) do
				if k == "foreground" or k == "background" then
					token[k] = tostring(M.decimal_to_hex_color(v))
				else
					token[k] = v
				end
			end
		end
		table.insert(tokens, token)
		::continue::
	end

	return tokens
end

return M
