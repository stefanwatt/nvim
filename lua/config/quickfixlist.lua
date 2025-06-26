local function store_original_keymap(mode, lhs)
    local keymaps = vim.api.nvim_get_keymap(mode)
    for _, keymap in ipairs(keymaps) do
        if keymap.lhs == lhs then
            return keymap
        end
    end
    return nil
end

local function restore_keymap(original)
	if original then
		vim.keymap.set(original.mode, original.lhs, original.rhs, {
			silent = original.silent == 1,
			noremap = original.noremap == 1,
			expr = original.expr == 1,
			buffer = original.buffer ~= 0 and original.buffer or nil,
		})
	else
		return function(mode, lhs)
			vim.keymap.del(mode, lhs)
		end
	end
end

local original_keymaps = {}

vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function(event)
		original_keymaps["n_C-p"] = store_original_keymap("n", "")
		original_keymaps["i_C-p"] = store_original_keymap("i", "")
		original_keymaps["n_C-n"] = store_original_keymap("n", "")
		original_keymaps["i_C-n"] = store_original_keymap("i", "")
		vim.keymap.set({ "n", "i" }, "<C-p>", "cprev", { silent = true })
		vim.keymap.set({ "n", "i" }, "<C-n>", "cnext", { silent = true })
	end,
})

vim.api.nvim_create_autocmd("QuitPre", {
	pattern = "*",
	callback = function(event)
		if vim.bo.filetype == "qf" then
			restore_keymap(original_keymaps["n_C-p"])("n", "")
			restore_keymap(original_keymaps["i_C-p"])("i", "")
			restore_keymap(original_keymaps["n_C-n"])("n", "")
			restore_keymap(original_keymaps["i_C-n"])("i", "")
		end
	end,
})

function FormatQfList(info)
  local items = vim.fn.getqflist()
  local results = {}
  
  -- Find the maximum width needed for the filename column
  local max_filename_width = 0
  for _, item in ipairs(items) do
    local filename = vim.fn.bufname(item.bufnr) or item.filename or "[No Name]"
    filename = vim.fn.fnamemodify(filename, ":t") -- Get just the filename without path
    max_filename_width = math.max(max_filename_width, string.len(filename))
  end
  
  -- Format each entry
  for i = info.start_idx, info.end_idx do
    local item = items[i]
    local filename = vim.fn.bufname(item.bufnr) or item.filename or "[No Name]"
    filename = vim.fn.fnamemodify(filename, ":t") -- Get just the filename without path
    
    -- Format line with fixed-width columns
    local line = string.format("%-" .. max_filename_width .. "s | %4d:%-3d | %s", 
                               filename, item.lnum, item.col, item.text)
    table.insert(results, line)
  end
  
  return results
end
