local function parse_key(key)
	local start_row, start_col, end_row, end_col = string.match(key, "(%d+):(%d+)-(%d+):(%d+)")
	return tonumber(start_row), tonumber(start_col), tonumber(end_row), tonumber(end_col)
end

local function create_preview_buffer()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].modifiable = true
	vim.bo[buf].bufhidden = "wipe"
	return buf
end

local function has_ts_parser(lang)
	if vim.fn.has("nvim-0.11") == 1 then
		return vim.treesitter.language.add(lang)
	else
		return pcall(vim.treesitter.language.add, lang)
	end
end

local ts_attach = function(bufnr, ft)
	local lang = vim.treesitter.language.get_lang(ft)
	local loaded = lang and has_ts_parser(lang)
	if lang and loaded then
		local ok, err = pcall(vim.treesitter.start, bufnr, lang)
		if not ok then
			print(string.format("unable to attach treesitter highlighter for filetype '%s': %s", ft, err))
		end
		return ok
	end
end

local function setup_preview_buffer(bufnr, content, filetype)
	-- Set the buffer content
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
	vim.bo[bufnr].filetype = filetype

	-- Enable syntax highlighting
	if filetype then
		-- Try treesitter first (Neovim >= 0.9)
		local success = false
		if vim.fn.has("nvim-0.9") == 1 then
			success = ts_attach(bufnr, filetype)
		end

		-- Fallback to regular syntax highlighting
		if not success then
			vim.cmd("filetype detect")
		end
	end
end

local function get_buffer_highlights(bufnr, start_line, end_line)
	local highlights = {}

	local ts = vim.treesitter
	local ft = vim.bo[bufnr].filetype
	local lang = ts.language.get_lang(ft)
	local parser = ts.get_parser(bufnr, lang)
	local tree = parser:parse()[1]
	local root = tree:root()

	local query = ts.query.get(lang, "highlights")
	for id, node, metadata in query:iter_captures(root, bufnr, start_line, end_line) do
		local name = query.captures[id]
		local start_row, start_col, end_row, end_col = node:range()
		local key = string.format("%d:%d-%d:%d", start_row, start_col, end_row, end_col)
		highlights[key] = {
			row = start_row,
			start_col = start_col,
			end_col = end_col,
			hl_group = id,
		}
	end

	return highlights
end

local function generate_preview_grid(bufnr, start_line, end_line)
	local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
	assert(lines ~= nil, "lines cannot be nil")
	local content_rows = {}
	local highlights = get_buffer_highlights(bufnr, start_line - 1, end_line - 1)

	local line_tokens = {}
	for key, hl in pairs(highlights) do
		local start_row, start_col, end_row, end_col = parse_key(key)
		local row_idx = start_row + 1

		if not line_tokens[row_idx] then
			line_tokens[row_idx] = {}
		end

		local text = lines[row_idx] ~= nil and lines[row_idx]:sub(start_col + 1, end_col) or ""
		table.insert(line_tokens[row_idx], {
			start_col = start_col,
			end_col = end_col,
			hl_group = hl.hl_group,
			text = text,
		})
	end

	for row_idx, tokens in pairs(line_tokens) do
		table.sort(tokens, function(a, b)
			return a.start_col < b.start_col
		end)

		content_rows[row_idx] = {
			row = row_idx,
			tokens = {},
		}
		for _, token in ipairs(tokens) do
			table.insert(content_rows[row_idx].tokens, {
				classes = "",
				hl_group = token.hl_group,
				text = token.text,
			})
		end
	end

	for i, line in ipairs(lines) do
		if content_rows[i] == nil then
			-- assert(line == "", "line should be empty if theres no tokens")
			content_rows[i] = { row = i, tokens = {} }
		end
	end
	return content_rows
end

local M = {}

function M.get_highlighted_content(filename, start_line, end_line)
	local filetype = vim.filetype.match({ filename = filename })
	local bufnr = create_preview_buffer()
	local content = vim.fn.readfile(filename)
	setup_preview_buffer(bufnr, content, filetype)
	local grid = generate_preview_grid(bufnr, start_line, end_line)
	vim.api.nvim_buf_delete(bufnr, { force = true })
	return grid
end

return M
