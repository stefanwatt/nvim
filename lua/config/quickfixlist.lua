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
