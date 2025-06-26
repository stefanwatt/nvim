return {
	"ibhagwan/fzf-lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"ahmedkhalf/project.nvim",
	},
	keys = {
		{ "<leader>f",                                  name = "Find" },
		{
			"gd",
			"<cmd>lua require('fzf-lua').lsp_definitions({ jump1 = true })<CR>",
			desc = "[g]oto [d]efinition",
		},
		{
			vim.g.keymaps.fzf_lua_find_references,
			function()
				require("fzf-lua").lsp_references({
					includeDeclaration = false,
					jump_to_single_result = true,
				})
			end,
			desc = "[f]ind [r]eferences",
		},
		{ vim.g.keymaps.fzf_lua_find_buffer_symbols,    "<cmd>FzfLua lsp_document_symbols<cr>",  desc = "[f]ind document [s]ymbols" },
		{ vim.g.keymaps.fzf_lua_find_workspace_symbols, "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "[f]ind workspace [S]ymbols" },
		{ vim.g.keymaps.fzf_lua_find_help,              "<cmd>FzfLua helptags<cr>",              desc = "[f]ind [h]elp" },
		{ vim.g.keymaps.fzf_lua_find_buffer,            "<cmd>FzfLua buffers<cr>",               desc = "[f]ind [b]uffers" },
		{ vim.g.keymaps.fzf_lua_find_project,           "<cmd>FzfProject<cr>",                   desc = "[f]ind [p]roject" },
		{ vim.g.keymaps.fzf_lua_find_files,             "<cmd>FzfLua git_files<cr>",             desc = "[f]ind [f]iles" },
		{ vim.g.keymaps.fzf_lua_live_grep,              "<cmd>FzfLua live_grep<cr>",             desc = "[f]ind [w]ord" },
		{
			mode = "v",
			vim.g.keymaps.fzf_lua_live_grep,
			"<cmd>FzfLua grep_visual<cr>",
			desc = "[f]ind [w]ord",
		},
		{
			vim.g.keymaps.fzf_lua_find_todo,
			"<cmd>lua require('fzf-lua').grep({search='TODO|HACK|PERF|NOTE|FIXME|FIX', no_esc=true})<CR>",
			desc = "[f]ind [t]odo",
		},
	},
	config = function()
		local fzflua = require("fzf-lua")
		fzflua.setup({
			winopts = { preview = { delay = 250 } },
			keymap = { fzf = { ["ctrl-q"] = "select-all+accept", ["ctrl-alt-q"] = "accept" } },
		})
		vim.api.nvim_create_user_command("FzfProject", function()
			local opts = {}
			opts.prompt = "Projects> "
			opts.actions = {
				["default"] = function(selected)
					vim.cmd("FzfLua files cwd=" .. selected[1])
				end,
			}
			local project = require("project_nvim")
			local projects = project.get_recent_projects()
			local recent_projects = {}
			for i = #projects, 1, -1 do
				recent_projects[#recent_projects + 1] = projects[i]
			end
			fzflua.fzf_exec(recent_projects, opts)
		end, { nargs = 0 })
	end,
}
