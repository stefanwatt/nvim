local M = {}

function M.handle_task_list()
    vim.opt.conceallevel = 2
    vim.opt.concealcursor = "nc"
    local buf = vim.api.nvim_get_current_buf()
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local parser = vim.treesitter.get_parser(buf, "markdown")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("markdown", [[
        (task_list_marker_checked) @checked
        (task_list_marker_unchecked) @unchecked
    ]])
    local ns = vim.api.nvim_create_namespace("task_list")
    for id, node in query:iter_captures(tree:root(), buf, 0, -1) do
        local start_row, start_col, end_row, end_col = node:range()
        local text = id == 1 and "☑" or "☐"
        local virt_text = { { text, "TaskList" } }
        vim.api.nvim_buf_set_extmark(buf, ns, start_row, start_col - 2, {
            virt_text = virt_text,
            virt_text_pos = "overlay",
            end_col = end_col,
            hl_mode = "combine",
            priority = 1000,
            conceal = " "
        })
    end
end

function M.inspect_current_line()
    local buf = vim.api.nvim_get_current_buf()
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1

    local parser = vim.treesitter.get_parser(buf, "markdown")
    local tree = parser:parse()[1]

    -- Function to print node info
    local function print_node(node, level)
        local indent = string.rep("  ", level)
        local start_row, start_col, end_row, end_col = node:range()
        local node_type = node:type()
        local text = vim.treesitter.get_node_text(node, buf)
        print(string.format("%sType: %s", indent, node_type))
        print(string.format("%sText: %s", indent, text))
        print(string.format("%sRange: %d,%d to %d,%d", indent, start_row, start_col, end_row, end_col))

        for child in node:iter_children() do
            print_node(child, level + 1)
        end
    end

    for node in tree:root():iter_children() do
        local start_row, _, end_row, _ = node:range()
        if start_row <= row and end_row >= row then
            print_node(node, 0)
        end
    end
end

return M
