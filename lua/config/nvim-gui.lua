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

local whitespace_count = 1

---@param ts_node TSNode
---@param parent NvimGuiNode
---@param depth number
---@param query TSQuery
---@returns children NvimGuiNode[]
local function walk_node(ts_node, parent, depth, query, bufnr)
    local children = {}
    local last_end_pos = { top = parent.start_top, left = parent.start_left }
    for child, name in ts_node:iter_children() do
        local id = child:id()
        local start_row, start_col, end_row, end_col = child:range()
        while start_row > last_end_pos.top do
            local line_break = {
                text = "\n",
                id = id .. tostring(whitespace_count),
                start_top = last_end_pos.top,
                start_left = 0,
                end_top = last_end_pos.top + 1,
                end_left = 0,
                line_break = true,
                children = {},
            }
            table.insert(parent.children, 1, line_break)
            whitespace_count = whitespace_count + 1
            last_end_pos.top = last_end_pos.top + 1
            last_end_pos.left = 0
        end
        if start_col > last_end_pos.left then
            local space = {
                text = string.rep(" ", start_col - last_end_pos.left),
                id = id .. tostring(whitespace_count),
                start_top = last_end_pos.top,
                start_left = last_end_pos.left,
                end_top = last_end_pos.top,
                end_left = start_col,
                children = {},
                space = true,
            }
            table.insert(children, space)
            whitespace_count = whitespace_count + 1
            last_end_pos.left = start_col
        end
        local start_top = start_row - parent.start_top
        local start_left = start_col - parent.start_left
        local end_top = start_top + (end_row - start_row)
        local end_left = end_top ~= start_top and end_col or (start_left + (end_col - start_col))
        local child_node = {
            id = id,
            text = "",
            hl_group = nil,
            children = {},
            start_top = start_top,
            start_left = start_left,
            end_top = end_top,
            end_left = end_left,
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
            child_node.children = walk_node(child, child_node, depth + 1, query, bufnr)
            -- if it has children,then the text will be on them
            child_node.text = nil
        end
        table.insert(children, child_node)
        last_end_pos = { top = child_node.end_top, left = child_node.end_left }
    end
    return children
end

local function write_to_buffer(content)
    vim.api.nvim_input(":vsplit<cr>")
    local buf = vim.api.nvim_create_buf(false, true)
    local lines = vim.split(vim.inspect(content), "\n")
    vim.schedule(function()
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_set_current_buf(buf)
    end)
end

M.get_tree_as_table = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local language_tree = parsers.get_parser(bufnr)
    local tree = language_tree:parse()[1]
    local lang = language_tree:lang()
    local root = tree:root()
    local query = vim.treesitter.query.get(lang, "highlights")
    local start_row, start_col, end_row, end_col = root:range()
    local id = root:id()
    local root_node = {
        id = id,
        start_top = 0,
        start_left = 0,
        end_top = end_row,
        end_left = end_col,
        children = {},
        root = true,
    }
    local last_end_top = 0
    while start_row > last_end_top do
        local line_break = {
            text = "\n",
            id = id .. tostring(whitespace_count),
            start_top = last_end_top,
            start_left = 0,
            end_top = last_end_top + 1,
            end_left = 0,
            children = {},
        }
        table.insert(root_node.children, 1, line_break)
        whitespace_count = whitespace_count + 1
        last_end_top = last_end_top + 1
    end

    local ok, text = pcall(vim.treesitter.get_node_text, root, bufnr)
    if ok then
        root_node.text = text
    end
    root_node.children = walk_node(root, root_node, 0, query, bufnr)
    write_to_buffer(root_node)
end

return M
