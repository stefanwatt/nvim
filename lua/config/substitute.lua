local opts = { silent = true }

local function get_substitute_parts(cmdline)
	local pattern = "^(%%s/)(.*)$"
	local before, after = cmdline:match(pattern)
	if before and after then
		local search_end = after:find("/")
		if not search_end then
			return
		end
		local search_term = after:sub(1, search_end - 1)
		local replace_and_flags = after:sub(search_end)
		local is_very_magic = search_term:sub(1, 2) == "\\v"
		if is_very_magic then
			search_term = search_term:sub(3, -2)
		end
		return before, search_term, replace_and_flags, is_very_magic
	end
end

local function toggle_sub_magic()
	local cmdline = vim.fn.getcmdline()
	local cmdpos = vim.fn.getcmdpos()
	local before, search_term, replace_and_flags, is_very_magic = get_substitute_parts(cmdline)

	if before and search_term then
		if is_very_magic then
			search_term = search_term:sub(2, -2)
			cmdpos = cmdpos - 4
		else
			search_term = "\\v(" .. search_term .. ")"
			cmdpos = cmdpos + 4
		end
		local new_cmdline = before .. search_term .. replace_and_flags
		vim.fn.setcmdline(new_cmdline, cmdpos)
		vim.schedule(function()
			vim.api.nvim_input("<space><BS>")
		end)
	end
end

local function toggle_sub_flag(flag_to_toggle)
	local cmdline = vim.fn.getcmdline()
	local cmdpos = vim.fn.getcmdpos()
	local pattern = "^(%%s/.-/)(.*)(/[gci]*)$"
	local before, middle, flags = cmdline:match(pattern)

	if before and middle then
		local new_flags = ""
		local flag_set = {}

		for flag in (flags or ""):gmatch("%a") do
			flag_set[flag] = true
		end

		flag_set[flag_to_toggle] = not flag_set[flag_to_toggle]

		for _, flag in ipairs({ "g", "c", "i" }) do
			if flag_set[flag] then
				new_flags = new_flags .. flag
			end
		end

		local new_cmdline = before .. middle .. (new_flags ~= "" and "/" .. new_flags or "")
		vim.fn.setcmdline(new_cmdline, cmdpos)

		vim.schedule(function()
			vim.api.nvim_input("<space><BS>")
		end)
	end
end

local function jump()
	local cmdline = vim.fn.getcmdline()
	local cmdpos = vim.fn.getcmdpos()
	local before, search_term, replace_and_flags, is_very_magic = get_substitute_parts(cmdline)

	if before and search_term then
		local search_start = #before + 1
		if is_very_magic then
			search_start = search_start + 3
		end
		local search_end = search_start + #search_term

		local target_pos
		if cmdpos > search_end then
			target_pos = search_start
		else
			target_pos = search_end + 1
		end

    --HACK: don't know why, but didnt work with vim.fn.setcmdpos
		local move_count = math.abs(target_pos - cmdpos)
		local move_direction = target_pos > cmdpos and "Right" or "Left"

		for _ = 1, move_count do
			vim.api.nvim_input("<" .. move_direction .. ">")
		end
	end
end

local function setup_substitute_keymaps()
	local temp_keymaps = {
		{ lhs = "<S-CR>", rhs = "<CR>a" },
		{
			lhs = "<A-m>",
			rhs = toggle_sub_magic,
		},
		{
			lhs = "<A-g>",
			rhs = function()
				toggle_sub_flag("g")
			end,
		},
		{
			lhs = "<A-c>",
			rhs = function()
				toggle_sub_flag("c")
			end,
		},
		{
			lhs = "<A-i>",
			rhs = function()
				toggle_sub_flag("i")
			end,
		},
		{
			lhs = "<Tab>",
			rhs = jump,
		},
	}

	for _, keymap in ipairs(temp_keymaps) do
		vim.keymap.set("c", keymap.lhs, keymap.rhs, opts)
	end

	local augroup = vim.api.nvim_create_augroup("substitute", { clear = true })
	vim.api.nvim_create_autocmd("CmdlineLeave", {
		group = augroup,
		pattern = "*",
		once = true,
		callback = function()
			for _, keymap in ipairs(temp_keymaps) do
				vim.api.nvim_del_keymap("c", keymap.lhs)
			end
		end,
	})
end

vim.keymap.set("v", "<leader>R", function()
	vim.cmd('normal! "vy')
	local text = vim.fn.getreg("v")

	setup_substitute_keymaps()

	vim.api.nvim_input(":<C-u>" .. "%s/\\v(" .. text .. ")//gci<Left><Left><Left><Left>")
end, { noremap = true, silent = true, desc = "substitute with visual selection" })

vim.keymap.set("n", "<leader>R", function()
	setup_substitute_keymaps()

	vim.api.nvim_input(":<C-u>%s/\\v()//gci<Left><Left><Left><Left>")
end, { noremap = true, silent = true, desc = "substitute" })
