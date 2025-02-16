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
---@field id string
---@field text string|nil
---@field hl_group string|nil
---@field start_top number
---@field end_top number
---@field start_left number
---@field end_left number
---@field start_row number
---@field start_col number
---@field end_row number
---@field end_col number
---@field root boolean
---@field line_break boolean
---@field space boolean
---@field children NvimGuiNode[]
---
---

local function is_even(x)
	return x >= 0
end

---@param children NvimGuiNode[]
---@param pos number|nil
---@param child NvimGuiNode
local function insert_child(children, pos, child)
	vim.validate({
		id = { child.id, "string" },
		text = { child.text, "string", true },
		hl_group = { child.hl_group, "string", true },
		start_top = { child.start_top, is_even, "positive number" },
		end_top = { child.end_top, is_even, "positive number" },
		start_left = { child.start_left, is_even, "positive number" },
		end_left = { child.end_left, is_even, "positive number" },
		root = { child.root, "boolean" },
		line_break = { child.line_break, "boolean" },
		space = { child.space, "boolean" },
		children = { child.children, "table" },
	})
	if pos == nil then
		table.insert(children, child)
	else
		table.insert(children, pos, child)
	end
end

local whitespace_count = 0
local line_breaks = {}

---@param start_col number
---@param children NvimGuiNode[]
---@param parent_start_left number
---@param start_top number
---@param child_index number
---@return number
function M.calc_start_left(start_col, parent_start_left, children, start_top, child_index)
	if child_index == 1 then
		return 0
	else
		local left_sibling = children[child_index - 1]
		assert(left_sibling ~= nil)
		-- if left_sibling.start_top ~= start_top and left_sibling.start_top > whitespace_count then -- TODO: i dont understand this anymore
		if left_sibling.start_top ~= start_top then
			-- start_left = left_sibling.end_left - whitespace_count
			return 0
		else
			return left_sibling.end_left + 1
		end
	end
end

---@param child TSNode
---@param bufnr number
---@return string
function M.map_node_text(child, bufnr)
	local res = ""
	local ok, text = pcall(vim.treesitter.get_node_text, child, bufnr)
	if ok then
		res = text
	end
	return res
end

---@param query vim.treesitter.Query
---@param child TSNode
---@param bufnr number
---@param start_row number
---@return string
function M.map_hl_group(query, child, bufnr, start_row)
	local hl_group = ""
	for capture_id, _ in query:iter_captures(child, bufnr, start_row, start_row + 1) do
		if capture_id then
			hl_group = query.captures[capture_id]
			break
		end
	end
	return hl_group
end

---@param id string
---@param start_top number
---@param end_top number
---@param start_left number
---@param end_left number
---@return NvimGuiNode
function M.map_default_child_node(id, start_top, end_top, start_left, end_left)
	return {
		id = id,
		text = "",
		hl_group = "",
		start_top = start_top,
		end_top = end_top,
		start_left = start_left,
		end_left = end_left,
		root = false,
		line_break = false,
		space = false,
		children = {},
		start_row = 0,
		start_col = 0,
		end_row = 0,
		end_col = 0,
	}
end

---@param start_top number
---@param parent NvimGuiNode
---@param child_index number
---@param children NvimGuiNode[]
---@return number
function M.calc_expected_left(start_top, parent, child_index, children)
	if child_index ~= 1 then
		-- assert(#children >= child_index - 1, "not enough children to find last child")
		-- vim.print("children: ", children, "children[1]: ", children[1], " child_index = ", child_index)
		if children[child_index - 1] then
			return children[child_index - 1].end_left
		end
	end
	return start_top == parent.start_top and parent.end_left or 0
end

---@param base_id string
---@param spaces number
---@param last_end_left number
---@param start_row number
---@param start_col number
---@param start_top number
---@return NvimGuiNode
function M.map_whitespace(
		base_id,
		spaces,
		last_end_left,
		start_row,
		start_col,
		start_top
)
	local space = {
		id = base_id .. tostring(whitespace_count),
		text = string.rep(" ", spaces),
		hl_group = "",
		start_top = start_top,
		end_top = start_top,
		start_left = last_end_left + 1,
		end_left = last_end_left + 1 + spaces,
		root = false,
		line_break = false,
		space = true,
		children = {},
		start_row = start_row,
		start_col = start_col,
		end_row = start_row,
		end_col = start_col + spaces,
	}
	whitespace_count = whitespace_count + 1
	return space
end

---@param child TSNode
---@param left_sibling TSNode | nil
---@param parent NvimGuiNode
---@param parent_ts_node TSNode
---@param children NvimGuiNode[]
---@param rows_indented boolean[]
---@param line_breaks_inserted number
---@param bufnr number
---@param query vim.treesitter.Query
---@param depth number
---@param child_index number
function M.handle_child(
		child,
		left_sibling,
		parent,
		parent_ts_node,
		children,
		rows_indented,
		line_breaks_inserted,
		bufnr,
		query,
		depth,
		child_index
)
	local id = child:id()
	local start_row, start_col, end_row, end_col = child:range()
	local start_top = start_row - parent.start_top
	local start_left = M.calc_start_left(start_col, parent.start_left, children, start_top, child_index)
	local end_top = start_top + (end_row - start_row)
	local end_left = end_top ~= start_top and end_col or (start_left + (end_col - start_col))

	if left_sibling ~= nil then
		local ls_start_row, ls_start_col, ls_end_row, ls_end_col = left_sibling:range()
		local diff = start_col - ls_end_col
		local ls_node = children[child_index - 1]
		if start_row == ls_start_row and diff > 0 then
			local space = M.map_whitespace(
				id,
				diff,
				ls_node.end_left,
				ls_node.start_row,
				ls_node.start_col + 1,
				ls_node.start_top
			)
			insert_child(children, child_index, space)
			start_left = space.end_left + 1
			end_left = end_left + diff
		end
	end

	-- local expected_left = M.calc_expected_left(start_top, parent, child_index, children)
	-- if start_left > expected_left and not rows_indented[start_row] then
	-- insert_indent(id, start_col, expected_left, start_top, end_top, children, line_breaks_inserted)
	-- 	rows_indented[start_row] = true
	-- 	whitespace_count = whitespace_count + 1
	-- 	expected_left = expected_left + 1
	-- end

	local child_node = M.map_default_child_node(id, start_top, end_top, start_left, end_left)
	child_node.start_row,
	child_node.start_col,
	child_node.end_row,
	child_node.end_col = child:range()
	child_node.hl_group = M.map_hl_group(query, child, bufnr, start_row)
	child_node.text = M.map_node_text(child, bufnr)
	child_node.end_left = start_left + (#child_node.text - 1)

	if child:child_count() > 0 then
		child_node.children =
				M.build_subtree(child, child_node, depth + 1, query, bufnr, rows_indented, line_breaks_inserted, {})
		--NOTE: text will always be on leaf nodes -> remove text from parent if it has children
		child_node.text = nil
	end
	if child_index == 1 then
		assert(start_left == 0)
	end
	insert_child(children, nil, child_node)
end

---@param parent_ts_node TSNode
---@param parent NvimGuiNode
---@param depth number
---@param query vim.treesitter.Query
---@param rows_indented boolean[]
---@param line_breaks_inserted number
---@param children NvimGuiNode[]
---@returns NvimGuiNode[]
function M.build_subtree(parent_ts_node, parent, depth, query, bufnr, rows_indented, line_breaks_inserted, children)
	local i = #children + 1
	local last_top = parent.start_top + line_breaks_inserted
	local first_child = parent_ts_node:child(0)
	if first_child then
		local first_child_start_top = first_child:range()
		first_child_start_top = first_child_start_top - parent.start_top
		-- NOTE: insert leading line breaks
		while first_child_start_top > last_top do
			insert_child(parent.children, 1, M.map_line_break(first_child:id(), last_top))
			whitespace_count = whitespace_count + 1
			line_breaks_inserted = line_breaks_inserted + 1
			last_top = last_top + 1
		end

		local start_row, start_col, end_row, end_col = first_child:range()
		local p_start_row, p_start_col, p_end_row, p_end_col = parent_ts_node:range()
		if p_start_row ~= start_row then
			p_start_col = 0
		end
		local diff = start_col - p_start_col
		if diff > 0 then
			local space = M.map_whitespace(
				first_child:id(),
				diff,
				-1, --TODO: not super clean
				start_row,
				start_col,
				parent.start_top
			)
			insert_child(children, nil, space)
			i = i + 1
		end
	end
	local left_sibling = nil
	local ts_nodes = {}
	for child, name in parent_ts_node:iter_children() do
		local length_before = #children
		M.handle_child(
			child,
			left_sibling,
			parent,
			parent_ts_node,
			children,
			rows_indented,
			line_breaks_inserted,
			bufnr,
			query,
			depth,
			i
		)
		local length_after = #children
		i = i + (length_after - length_before)
		ts_nodes[i] = child
		left_sibling = child
	end
	-- vim.print("children", children)
	local updated_children = {}
	local prev_child = nil

	for j, child in ipairs(children) do
		if j == 1 then
			-- Insert the first child
			insert_child(updated_children, nil, child)
			prev_child = child
		else
			assert(prev_child, "must have prev child if j > 1")
			-- Insert missing line breaks if necessary
			if child.start_top > prev_child.end_top then
				local linebreak = M.map_line_break(prev_child.id, prev_child.end_top)
				insert_child(updated_children, nil, linebreak)
				whitespace_count = whitespace_count + 1
				for k = 2, child.start_top - prev_child.end_top, 1 do
					linebreak = M.map_line_break(linebreak.id, linebreak.end_top)
					insert_child(updated_children, nil, linebreak)
					whitespace_count = whitespace_count + 1
				end
				if ts_nodes[j] then --TODO: why is this nil??
					local start_row, start_col = ts_nodes[j]:range()
					local source_text = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, true)[1]
					local leading_spaces = nil
					if source_text:match("^%s+") then
						leading_spaces = #source_text:match("^%s+")
					end
					if leading_spaces and leading_spaces > 0 then
						local space = M.map_whitespace(
							prev_child.id,
							leading_spaces,
							-1,
							start_row,
							start_col,
							linebreak.end_top
						)
						insert_child(updated_children, nil, space)
						child.start_left = child.start_left + leading_spaces
						child.end_left = child.end_left + leading_spaces
					end
				end
			end
			-- Insert the current child
			insert_child(updated_children, nil, child)
			prev_child = child
		end
	end

	-- vim.print("updated_children", updated_children)

	return updated_children
end

---@param id string
---@param last_end_top number
---@return NvimGuiNode
function M.map_line_break(id, last_end_top)
	return {
		id = id .. tostring(whitespace_count),
		text = "\n",
		hl_group = "",
		start_top = last_end_top,
		end_top = last_end_top + 1,
		start_left = 0,
		end_left = 0,
		root = false,
		line_break = true,
		space = false,
		children = {},
		--TODO:
		start_row = 0,
		start_col = 0,
		end_row = 0,
		end_col = 0,
	}
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
function M.get_tree_as_table(root, lang, bufnr)
	local query = vim.treesitter.query.get(lang, "highlights")
	local start_row, start_col, end_row, end_col = root:range()
	local id = root:id()
	---@type NvimGuiNode
	local root_node = {
		id = id,
		text = "",
		hl_group = "",
		start_top = 0,
		end_top = end_row,
		start_left = 0,
		end_left = end_col,
		start_row = 0,
		start_col = 0,
		end_row = end_row,
		end_col = end_col,
		root = true,
		line_break = false,
		space = false,
		children = {},
	}

	if start_col > 0 then
		local space = M.map_whitespace(
			id,
			start_col,
			-1,
			start_row,
			0,
			0
		)
		insert_child(root_node.children, nil, space)
	end
	local ok, text = pcall(vim.treesitter.get_node_text, root, bufnr)
	if ok then
		root_node.text = text
	end
	root_node.children = M.build_subtree(root, root_node, 0, query, bufnr, {}, 0, root_node.children)
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
local function test_tree_update() end
return M
