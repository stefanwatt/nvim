---@class Range4
---@field [1] integer start row
---@field [2] integer start column
---@field [3] integer end row
---@field [4] integer end column
---
---@class vim.treesitter.query.TSMetadata
---@field range? vim.Range
---@field conceal? string
---@field [integer] vim.treesitter.query.TSMetadata
---@field [string] integer|string

---@class Range2
---@field [1] integer start row
---@field [2] integer end row

---@class Range6
---@field [1] integer start row
---@field [2] integer start column
---@field [3] integer start bytes
---@field [4] integer end row
---@field [5] integer end column
---@field [6] integer end bytes

---@alias Range Range2|Range4|Range6
---@alias TSCallbackName
---| 'changedtree'
---| 'bytes'
---| 'detach'
---| 'child_added'
---| 'child_removed'

---@alias TSCallbackNameOn
---| 'on_changedtree'
---| 'on_bytes'
---| 'on_detach'
---| 'on_child_added'
---| 'on_child_removed'

--- @type table<TSCallbackNameOn,TSCallbackName>
local TSCallbackNames = {
	on_changedtree = "changedtree",
	on_bytes = "bytes",
	on_detach = "detach",
	on_child_added = "child_added",
	on_child_removed = "child_removed",
}
---Information for Query, see |vim.treesitter.query.parse()|
---@class vim.treesitter.QueryInfo
---
---List of (unique) capture names defined in query.
---@field captures string[]
---
---Contains information about predicates and directives.
---Key is pattern id, and value is list of predicates or directives defined in the pattern.
---A predicate or directive is a list of (integer|string); integer represents `capture_id`, and
---string represents (literal) arguments to predicate/directive. See |treesitter-predicates|
---and |treesitter-directives| for more details.
---@field patterns table<integer, (integer|string)[][]>

---@class vim.treesitter.Query
---@field lang string name of the language for this parser
---@field captures string[] list of (unique) capture names defined in query
---@field info vim.treesitter.QueryInfo contains information used in the query (e.g. captures, predicates, directives)
---@field query TSQuery userdata query object
---@field iter_captures fun(self: vim.treesitter.Query,node:TSNode, source:(integer|string),start?: integer, stop?:integer):fun(end_line: integer|nil): integer, TSNode, vim.treesitter.query.TSMetadata, TSQueryMatch
---
---@class vim.treesitter.LanguageTree
---@field parse fun(self: vim.treesitter.LanguageTree,range: boolean|Range|nil): table<integer, TSTree>
---@field private _callbacks table<TSCallbackName,function[]> Callback handlers
---@field package _callbacks_rec table<TSCallbackName,function[]> Callback handlers (recursive)
---@field private _children table<string,vim.treesitter.LanguageTree> Injected languages
---@field private _injection_query vim.treesitter.Query Queries defining injected languages
---@field private _injections_processed boolean
---@field private _opts table Options
---@field private _parser TSParser Parser for language
---@field private _has_regions boolean
---@field private _regions table<integer, Range6[]>?
---List of regions this tree should manage and parse. If nil then regions are
---taken from _trees. This is mostly a short-lived cache for included_regions()
---@field private _lang string Language name
---@field private _parent? vim.treesitter.LanguageTree Parent LanguageTree
---@field private _source (integer|string) Buffer or string to parse
---@field private _trees table<integer, TSTree> Reference to parsed tree (one for each language).
---Each key is the index of region, which is synced with _regions and _valid.
---@field private _valid boolean|table<integer,boolean> If the parsed tree is valid
---@field private _logger? fun(logtype: string, msg: string)
---@field private _logfile? file*
---
---
---@class TSNode: userdata
---@field id fun(self: TSNode): string
---@field tree fun(self: TSNode): TSTree
---@field range fun(self: TSNode, include_bytes: false?): integer, integer, integer, integer
---@field range fun(self: TSNode, include_bytes: true): integer, integer, integer, integer, integer, integer
---@field start fun(self: TSNode): integer, integer, integer
---@field end_ fun(self: TSNode): integer, integer, integer
---@field type fun(self: TSNode): string
---@field symbol fun(self: TSNode): integer
---@field named fun(self: TSNode): boolean
---@field missing fun(self: TSNode): boolean
---@field extra fun(self: TSNode): boolean
---@field child_count fun(self: TSNode): integer
---@field named_child_count fun(self: TSNode): integer
---@field child fun(self: TSNode, index: integer): TSNode?
---@field named_child fun(self: TSNode, index: integer): TSNode?
---@field descendant_for_range fun(self: TSNode, start_row: integer, start_col: integer, end_row: integer, end_col: integer): TSNode?
---@field named_descendant_for_range fun(self: TSNode, start_row: integer, start_col: integer, end_row: integer, end_col: integer): TSNode?
---@field parent fun(self: TSNode): TSNode?
---@field child_containing_descendant fun(self: TSNode, descendant: TSNode): TSNode?
---@field next_sibling fun(self: TSNode): TSNode?
---@field prev_sibling fun(self: TSNode): TSNode?
---@field next_named_sibling fun(self: TSNode): TSNode?
---@field prev_named_sibling fun(self: TSNode): TSNode?
---@field named_children fun(self: TSNode): TSNode[]
---@field has_changes fun(self: TSNode): boolean
---@field has_error fun(self: TSNode): boolean
---@field sexpr fun(self: TSNode): string
---@field equal fun(self: TSNode, other: TSNode): boolean
---@field iter_children fun(self: TSNode): fun(): TSNode, string
---@field field fun(self: TSNode, name: string): TSNode[]
---@field byte_length fun(self: TSNode): integer
---@field __has_ancestor fun(self: TSNode, node_types: string[]): boolean
---
---@alias TSLoggerCallback fun(logtype: 'parse'|'lex', msg: string)
---
--- @class TSQueryMatch: userdata
--- @field captures fun(self: TSQueryMatch): table<integer,TSNode[]>
---
---@class TSParser: userdata
---@field parse fun(self: TSParser, tree: TSTree?, source: integer|string, include_bytes: boolean): TSTree, (Range4|Range6)[]
---@field reset fun(self: TSParser)
---@field included_ranges fun(self: TSParser, include_bytes: boolean?): integer[]
---@field set_included_ranges fun(self: TSParser, ranges: (Range6|TSNode)[])
---@field set_timeout fun(self: TSParser, timeout: integer)
---@field timeout fun(self: TSParser): integer
---@field _set_logger fun(self: TSParser, lex: boolean, parse: boolean, cb: TSLoggerCallback)
---@field _logger fun(self: TSParser): TSLoggerCallback

---@class TSTree: userdata
---@field root fun(self: TSTree): TSNode
---@field edit fun(self: TSTree, _: integer, _: integer, _: integer, _: integer, _: integer, _: integer, _: integer, _: integer, _:integer)
---@field copy fun(self: TSTree): TSTree
---@field included_ranges fun(self: TSTree, include_bytes: true): Range6[]
---@field included_ranges fun(self: TSTree, include_bytes: false): Range4[]

---@class TSQuery: userdata
---@field inspect fun(self: TSQuery): TSQueryInfo

---@class (exact) TSQueryInfo
---@field captures string[]
---@field patterns table<integer, (integer|string)[][]>

---@type number
local counter = 0

local M = {}

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
			local tree = M.get_tree_as_table(ts_tree:root(), language_tree:lang(), bufnr)
			-- vim.print(tree)
			vim.fn.rpcrequest(channel, "nvim-gui-buf-changed", tree)
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

---@param root TSNode
---@param lang vim.treesitter.Language
M.get_tokens = function(root, lang)
	local bufnr = vim.api.nvim_get_current_buf()
	local iterator, captures = get_hl_captures(bufnr, root, lang)
	if not iterator or captures == {} then
		return nil
	end

	local tokens = {}
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
		token.id = node:id() .. token.text
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

---@class NvimGuiNode
---@field text string|nil
---@field id string
---@field hl_group string|nil
---@field children NvimGuiNode[]
---@field start_top number
---@field start_left number
---@field end_top number
---@field end_left number
---@field root boolean
---@field line_break boolean
---@field space boolean

local whitespace_count = 4
local line_breaks = {}

---@param parent_ts_node TSNode
---@param parent NvimGuiNode
---@param depth number
---@param query vim.treesitter.Query
---@param rows_indented boolean[]
---@param line_breaks_inserted number
---@returns NvimGuiNode[]
local function walk_node(parent_ts_node, parent, depth, query, bufnr, rows_indented, line_breaks_inserted)
	---@type NvimGuiNode[]
	local children = {}

	local last_top = parent.start_top + line_breaks_inserted
	local first_child = parent_ts_node:child(0)
	if first_child then
		local first_child_start_top = first_child:range()
		first_child_start_top = first_child_start_top - parent.start_top
		while first_child_start_top > last_top do
			---@type NvimGuiNode
			local line_break = {
				text = "\n",
				id = first_child:id() .. tostring(whitespace_count),
				start_top = last_top,
				start_left = 0,
				end_top = last_top + 1,
				end_left = 0,
				root = false,
				space = false,
				line_break = true,
				children = {},
			}
			table.insert(parent.children, 1, line_break)
			line_breaks_inserted = line_breaks_inserted + 1
			whitespace_count = whitespace_count + 1
			last_top = last_top + 1
		end
	end
	local i = 1
	for child, name in parent_ts_node:iter_children() do
		local id = child:id()
		local start_row, start_col, end_row, end_col = child:range()
		local start_top = start_row - parent.start_top
		local start_left = 0
		if i == 1 then
			start_left = start_col - parent.start_left
		else
			local last_child = children[i - 1]
			if not last_child then
				goto continue
			end
			if last_child.start_top ~= start_top and last_child.start_top > whitespace_count then
				start_left = last_child.start_left - whitespace_count
			else
				start_left = last_child.start_left + 1
			end
			::continue::
		end
		local end_top = start_top + (end_row - start_row)
		local end_left = end_top ~= start_top and end_col or (start_left + (end_col - start_col))
		local last_left = start_top == parent.start_top and parent.start_left or 0
		if not rows_indented[start_row] and start_left > last_left then
			---@type NvimGuiNode
			local space = {
				text = string.rep(" ", start_col - last_left),
				id = id .. tostring(whitespace_count),
				start_top = start_top,
				start_left = last_left,
				end_top = end_top,
				end_left = last_left + 1,
				children = {},
				space = true,
				root = false,
				line_break = false,
			}
			table.insert(children, line_breaks_inserted + 1, space)
			rows_indented[start_row] = true
			whitespace_count = whitespace_count + 1
			last_left = last_left + 1
		end

		---@type NvimGuiNode
		local child_node = {
			id = id,
			text = "",
			hl_group = nil,
			children = {},
			start_top = start_top,
			start_left = start_left,
			end_top = end_top,
			end_left = end_left,
			root = false,
			space = false,
			line_break = false,
		}
		local ok, text = pcall(vim.treesitter.get_node_text, child, bufnr)
		if ok then
			child_node.text = text
		end

		for id, _ in query:iter_captures(child, bufnr, start_row, start_row + 1) do
			if id then
				child_node.hl_group = query.captures[id]
				break
			end
		end
		if child:child_count() > 0 then
			child_node.children =
					walk_node(child, child_node, depth + 1, query, bufnr, rows_indented, line_breaks_inserted)
			-- if it has children,then the text will be on them
			child_node.text = nil
		end
		table.insert(children, child_node)
		i = i + 1
	end

	local last_child = children[1]
	local updated_children = {}
	table.insert(updated_children, last_child)
	for i = 2, #children do
		local child = children[i]
		if child and last_child and child.start_top > last_child.end_top then
			---@type NvimGuiNode
			local line_break = {
				text = "\n",
				id = last_child.id .. tostring(whitespace_count),
				start_top = last_child.end_top,
				start_left = 0,
				end_top = last_child.end_top + 1,
				end_left = 0,
				root = false,
				space = false,
				line_break = true,
				children = {},
			}
			table.insert(updated_children, line_break)
			whitespace_count = whitespace_count + 1
		end
		table.insert(updated_children, child)
		last_child = child
	end

	return updated_children
end

---@param node NvimGuiNode
---@param level number
---@return string
local function serialize_node(node, level)
	local prefix = string.rep(" ", level * 4)
	local text = node.text or ""
	return string.format(
		'%sNode "%s" (start: %d,%d, end: %d,%d) r(%s) s(%s) lb(%s) hl(%s)',
		prefix,
		text,
		node.start_top,
		node.start_left,
		node.end_top,
		node.end_left,
		node.root,
		node.space,
		node.line_break,
		node.hl_group
	)
end

local function tree_to_string(node, level, buffer)
	level = level or 0
	buffer = buffer or {}

	local node_string = serialize_node(node, level)
	node_string = node_string:gsub("\n", "\\n")
	table.insert(buffer, node_string)

	for _, child in ipairs(node.children or {}) do
		tree_to_string(child, level + 1, buffer)
	end

	return buffer
end

local function write_to_buffer(root)
	vim.api.nvim_input(":vsplit<cr>")
	local buf = vim.api.nvim_create_buf(false, true)
	local lines = tree_to_string(root)
	vim.schedule(function()
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		vim.api.nvim_set_current_buf(buf)
	end)
end

---@param root TSNode
---@param lang vim.treesitter.Language
---@param bufnr number
M.get_tree_as_table = function(root, lang, bufnr)
	local query = vim.treesitter.query.get(lang, "highlights")
	local start_row, start_col, end_row, end_col = root:range()
	local id = root:id()
	---@type NvimGuiNode
	local root_node = {
		id = id,
		start_top = 0,
		start_left = 0,
		end_top = end_row,
		end_left = end_col,
		children = {},
		root = true,
		line_break = false,
		space = false,
	}
	local ok, text = pcall(vim.treesitter.get_node_text, root, bufnr)
	if ok then
		root_node.text = text
	end
	root_node.children = walk_node(root, root_node, 0, query, bufnr, {}, 0)
	return root_node
end

M.print_tree_as_table = function()
	local bufnr = vim.api.nvim_get_current_buf()
	---@type vim.treesitter.Language
	local lang = parsers.get_buf_lang(bufnr)
	---@type vim.treesitter.LanguageTree
	local language_tree = parsers.get_parser(bufnr, lang)
	local tree = language_tree:parse({ 0, -1 })[1]
	local root = tree:root()
	local tree_table = M.get_tree_as_table(root, lang, bufnr)
	write_to_buffer(tree_table)
end

return M
