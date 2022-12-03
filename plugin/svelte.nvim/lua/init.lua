local ts_locals = require("nvim-treesitter.locals")
local ts_utils = require("nvim-treesitter.ts_utils")

local function i(value)
  print(vim.inspect(value))
end

function exportLines(startLineIndex, endLineIndex, lines, newFilePath)
  local concatenatedLines = ""
  for _, value in ipairs(lines) do
    concatenatedLines = concatenatedLines .. value
  end
  parseString(concatenatedLines)
  -- vim.api.nvim_buf_set_lines(0, startLineIndex, endLineIndex, false, {})
  -- vim.cmd("e " .. newFilePath)
  -- vim.api.nvim_buf_set_lines(0, 0, #lines - 1, false, lines)
  -- vim.cmd("w")
end

function parseString(sourceCode)
  local tsparser = vim.treesitter.get_string_parser(sourceCode, "svelte", {})
  -- local tsparser = vim.treesitter.get_parser(0, "svelte")
  local root = tsparser:parse()[1]:root()
  local query = vim.treesitter.parse_query('svelte', [[
    (each_statement) @var
  ]])
  for id, captures, metadata in query:iter_matches(root,0) do
    i(captures)
  end
end


  -- local node = ts_utils.get_node_at_cursor(0)
  -- local lspRange = ts_utils.node_to_lsp_range(node)
  -- local position = vim.api.nvim_win_get_cursor(0)

function getDefinitionPosition(line, character)
  local currentFilePath = vim.fn.expand("%:p")
  local params = {
    textDocument = { uri = currentFilePath },
    position = { line, character }
  }
  return vim.lsp.buf_request_sync(0, "textDocument/definition", params)
end



function example()
  local keys = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(keys, "i", true)
  local startLineIndex = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
  local endLineIndex = vim.api.nvim_buf_get_mark(0, ">")[1]
  local lines = vim.api.nvim_buf_get_lines(0, startLineIndex, endLineIndex, false)

  local currentFilePath = vim.fn.expand("%:p:h") .. "/"
  exportLines(startLineIndex, endLineIndex, lines, newFilePath)
  -- vim.ui.input({ prompt = "file path: ", default = currentFilePath }, function(newFilePath)
  --   if newFilePath == nil then
  --     return print("dialog aborted")
  --   end
  --   exportLines(startLineIndex, endLineIndex, lines, newFilePath)
  -- end)
end

vim.keymap.set("x", "<F5>", example, {})
