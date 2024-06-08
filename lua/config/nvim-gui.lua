local M = {}

local counter = 0

local function escape_special_characters(str)
	local replacements = {
		["="] = "eq",
		["."] = "dot",
		[","] = "comma",

		[" "] = "space",
		["/"] = "slash",
		["\\"] = "backslash",
		[":"] = "colon",
		[";"] = "semicolon",
		["("] = "lparen",
		[")"] = "rparen",
		["["] = "lbracket",
		["]"] = "rbracket",
		["{"] = "lbrace",
		["}"] = "rbrace",
		["<"] = "lt",
		[">"] = "gt",
		["?"] = "question",
		["!"] = "exclamation",
		["#"] = "hash",
		["$"] = "dollar",
		["%"] = "percent",
		["^"] = "caret",
		["&"] = "amp",
		["*"] = "asterisk",
		["+"] = "plus",
		["-"] = "dash",
		["_"] = "underscore",
		["~"] = "tilde",
		["|"] = "pipe",
		["'"] = "apostrophe",
		['"'] = "quote",
	}

	counter = counter + 1
	if replacements[str] then
		return replacements[str] .. tostring(counter)
	end
	return str
end

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

local parsers = require("nvim-treesitter.parsers")
local ts_utils = require("nvim-treesitter.ts_utils")
local highlighter = vim.treesitter.highlighter
---@param channel number
M.attach_buffer = function(channel)
	local bufnr = vim.api.nvim_get_current_buf()
	local language_tree = parsers.get_parser(bufnr)
	if not language_tree then
		return nil, {}
	end
	language_tree:register_cbs({
		on_changedtree = function(ranges, ts_tree)
			local tokens = M.get_tokens(ts_tree:root(), language_tree:lang())
			print("got tokens " .. tostring(#tokens))
			vim.fn.rpcrequest(channel, "nvim-gui-buf-changed", tokens)
		end,
	}, true)
	return "success"
end

M.decimal_to_hex_color = function(decimal)
	return string.format("#%06x", decimal)
end

---@alias HighlightIterator fun(end_line: integer?): integer, TSNode, vim.treesitter.query.TSMetadata, TSQueryMatch, table

---@param bufnr number
---@param node TSNode
---@param lang vim.treesitter.Language
---@return HighlightIterator|nil, table
local function get_hl_captures(bufnr, node, lang)
	local captures = {}

	local query = vim.treesitter.query.get(lang, "highlights")
	if not query then
		return nil, {}
	end
	return query:iter_captures(node, bufnr, 0, -1), query.captures
end

---@param base_id string
---@param seen_token_ids string[]
local function generate_unique_id(base_id, seen_token_ids)
	local token_id = base_id
	local suffix = 0
	while seen_token_ids[token_id] do
		suffix = suffix + 1
		token_id = base_id .. tostring(suffix)
	end
	return token_id
end

local function hash(str)
	local hash = 5381
	for i = 1, #str do
		local char = str:byte(i)
		hash = ((hash * 33) + char) % 2 ^ 32 -- Ensuring it stays within 32-bit integer range
	end
	return hash
end

---@param root TSNode
---@param lang vim.treesitter.Language
M.get_tokens = function(root, lang)
	local bufnr = vim.api.nvim_get_current_buf()
	local iterator, captures = get_hl_captures(bufnr, root, lang)
	if not iterator or captures == {} then
		return nil
	end

	local tokens = {}
	local seen_token_ids = {}
	for id, node, _ in iterator do
		local node_start_row, node_start_col, node_end_row, node_end_col = node:range()
		local token = {
			start_row = node_start_row,
			start_col = node_start_col,
			end_row = node_end_row,
			end_col = node_end_col,
		}
		local capture_name = captures[id]
		local ok, text =
			pcall(vim.api.nvim_buf_get_text, bufnr, node_start_row, node_start_col, node_end_row, node_end_col, {})
		token.text = ok and text[1] or ""

		-- local base_id = node:id() .. escape_special_characters(token.text)
		-- base_id = hash(base_id)
		-- local token_id = generate_unique_id(base_id, seen_token_ids)

		token.id = node:id() .. token.text
		-- seen_token_ids[token_id] = true

		token.hl_group = capture_name

		local hl_id = vim.api.nvim_get_hl_id_by_name(capture_name)
		local highlights = vim.api.nvim_get_hl(0, { name = "@" .. capture_name, link = false })
			or vim.api.nvim_get_hl(0, { name = capture_name, link = false })

		for k, v in pairs(highlights) do
			if k == "fg" or k == "bg" then
				token[k] = tostring(M.decimal_to_hex_color(v))
			else
				token[k] = v
			end
		end
		table.insert(tokens, token)
	end

	return tokens
end

local function get_hl_of_node(node, bufnr, query)
	local start_row, start_col, end_row, end_col = node:range()
	local iterator = query:iter_captures(node, bufnr, start_row, end_row)
	local tokens = {}
	for id, child, _ in iterator do
		local child_start_row, child_start_col, child_end_row, child_end_col = child:range()
		local token = {
			start_row = child_start_row,
			start_col = child_start_col,
			end_row = child_end_row,
			end_col = child_end_col,
		}
		local capture_name = query.captures[id]
		local ok, text =
			pcall(vim.api.nvim_buf_get_text, bufnr, child_start_row, child_start_col, child_end_row, child_end_col, {})
		token.text = ok and text[1] or ""
		token.hl_group = capture_name
		local highlights = vim.api.nvim_get_hl(0, { id = id })
		for k, v in pairs(highlights) do
			if k == "foreground" or k == "background" then
				token[k] = tostring(M.decimal_to_hex_color(v))
			else
				token[k] = v
			end
		end
		table.insert(tokens, token)
	end
	local ok, text = pcall(vim.api.nvim_buf_get_text, bufnr, start_row, start_col, end_row, end_col, {})
	return tokens, ok and text[1] or ""
end

local function walk_node(node, depth, query)
	for child, name in node:iter_children() do
		local hl, text = get_hl_of_node(child, 0, query)
		local indentation = string.rep("  ", depth)
		print(
			indentation .. " text: '" .. text .. "' type:",
			child:type(),
			" name: ",
			name,
			" highlights: ",
			vim.inspect(hl)
		)
		if child:child_count() > 0 then
			walk_node(child, depth + 1, query)
		end
	end
end

M.get_tree_as_table = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local language_tree = parsers.get_parser(bufnr)
	local tree = language_tree:parse()[1]
	local lang = language_tree:lang()
	local root = tree:root()
	local query = vim.treesitter.query.get(lang, "highlights")
	walk_node(root, 0, query)
end

M.print_tokens = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local language_tree = parsers.get_parser(bufnr)
	local tree = language_tree:parse()[1]
	local lang = language_tree:lang()
	local root = tree:root()
	local tokens = M.get_tokens(root, lang)
	vim.print(tokens)
end
return M
