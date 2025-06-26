local api = vim.api
local ns = api.nvim_create_namespace("kitty_md_headings")

-- Mapping of heading level to scale parameters
local scales = {
	{ s = 2, n = 0, d = 0 },   -- h1
	{ s = 1, n = 3, d = 2 },   -- h2 (1.5x)
	{ s = 1, n = 5, d = 4 },   -- h3 (1.25x)
	{ s = 1, n = 6, d = 5 },   -- h4 (1.2x)
	{ s = 1, n = 7, d = 6 },   -- h5 (1.16x)
	{ s = 1, n = 9, d = 8 },   -- h6 (1.125x)
}

local function get_scale_params(level)
	return scales[level] or scales[1]
end

-- Function to create the escape sequence for Kitty
local function create_kitty_sequence(text, level)
	local params = get_scale_params(level)
	local metadata = string.format("s=%d", params.s)
	if params.n > 0 and params.d > 0 then
		metadata = metadata .. string.format(":n=%d:d=%d", params.n, params.d)
	end

	return string.format("\27]66;%s;%s\7", metadata, text)
end

-- Send raw escape sequence to terminal
local function send_to_terminal(sequence)
	vim.api.nvim_chan_send(vim.v.stderr, sequence)
end

-- Function to test kitty terminal protocol
local function test_kitty_protocol()
	for i = 1, 6 do
		local text = "Level " .. i .. " Heading"
		local sequence = create_kitty_sequence(text, i)
		send_to_terminal(sequence)
		print(" - This should be sized according to level " .. i)
	end
end

-- Process markdown headings
local function process_headings(bufnr)
	-- Get all lines in the buffer
	local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local cursor_pos = api.nvim_win_get_cursor(0)

	for i, line in ipairs(lines) do
		-- Check if line is a heading
		local marker_pattern = "^(#+)%s+"
		local marker = line:match(marker_pattern)

		if marker then
			local level = marker:len()
			if level >= 1 and level <= 6 then
				-- Get the text part after the marker
				local text_start = #marker + 1
				while text_start <= #line and line:sub(text_start, text_start):match("%s") do
					text_start = text_start + 1
				end

				local text = line:sub(text_start):gsub("%s*$", "")

				-- Create and send the Kitty sequence
				local sequence = create_kitty_sequence(text, level)

				-- Set cursor to the beginning of the heading line
				api.nvim_win_set_cursor(0, { i, 0 })

				-- Insert the escape sequence at the current cursor position
				send_to_terminal(sequence)

				-- Also add syntax highlighting
				api.nvim_buf_add_highlight(bufnr, ns, "MarkdownH" .. level, i - 1, 0, -1)
			end
		end
	end

	-- Restore cursor position
	api.nvim_win_set_cursor(0, cursor_pos)
end

-- Add a user command to test kitty protocol
vim.api.nvim_create_user_command("TestKittyProtocol", function()
	test_kitty_protocol()
end, {})

-- Add a user command to process markdown headings
vim.api.nvim_create_user_command("KittyHeadings", function()
	process_headings(0)
end, {})

-- Optional: Autocommand to process headings on buffer changes
api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	pattern = "*.md",
	callback = function(args)
		process_headings(args.buf)
	end,
})

-- Define highlight groups for different heading levels
vim.cmd([[
    highlight MarkdownH1 guifg=#FF5555 gui=bold
    highlight MarkdownH2 guifg=#FFB86C gui=bold
    highlight MarkdownH3 guifg=#F1FA8C gui=bold
    highlight MarkdownH4 guifg=#50FA7B gui=bold
    highlight MarkdownH5 guifg=#8BE9FD gui=bold
    highlight MarkdownH6 guifg=#BD93F9 gui=bold
]])
