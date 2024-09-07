return {
	"ibhagwan/fzf-lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"ahmedkhalf/project.nvim",
	},
	keys = {
		{ "<leader>f",  name = "Find" },
		{
			"gd",
			"<cmd>lua require('fzf-lua').lsp_definitions({ jump_to_single_result = true })<CR>",
			desc = "[g]oto [d]efinition",
		},
		{
			"<leader>fr",
			function()
				require("fzf-lua").lsp_references({
					includeDeclaration = false,
					jump_to_single_result = true,
				})
			end,
			desc = "[f]ind [r]eferences",
		},
		{ "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>",  desc = "[f]ind document [s]ymbols" },
		{ "<leader>fS", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "[f]ind workspace [S]ymbols" },
		{ "<leader>fh", "<cmd>FzfLua helptags<cr>",              desc = "[f]ind [h]elp" },
		{ "<leader>fp", "<cmd>FzfProject<cr>",                   desc = "[f]ind [p]roject" },
		{ "<leader>ff", "<cmd>FzfLua git_files<cr>",             desc = "[f]ind [f]iles" },
		{ "<leader>fw", "<cmd>FzfLua live_grep<cr>",             desc = "[f]ind [w]ord" },
		{
			mode = "v",
			"<leader>fw",
			"<cmd>FzfLua grep_visual<cr>",
			desc = "[f]ind [w]ord",
		},
		{
			"<leader>ft",
			"<cmd>lua require('fzf-lua').grep({search='TODO|HACK|PERF|NOTE|FIXME|FIX', no_esc=true})<CR>",
			desc = "[f]ind [t]odo",
		},
	},
	config = function()
		local fzflua = require("fzf-lua")
		fzflua.setup({
			keymap = { fzf = { ["ctrl-q"] = "select-all+accept" } },
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
