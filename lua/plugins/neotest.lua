return {
	{
		"nvim-neotest/neotest",
		event = "VeryLazy",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"leoluz/nvim-dap-go",
			"fredrikaverpil/neotest-golang",
			"nvim-neotest/neotest-plenary",
			"nvim-neotest/neotest-vim-test",

			{
				"echasnovski/mini.indentscope",
				opts = function()
					-- disable indentation scope for the neotest-summary buffer
					vim.cmd([[
        autocmd Filetype neotest-summary lua vim.b.miniindentscope_disable = true
      ]])
				end,
			},
		},
		opts = {
			-- See all config options with :h neotest.Config
			discovery = {
				-- Drastically improve performance in ginormous projects by
				-- only AST-parsing the currently opened buffer.
				enabled = true,
				-- Number of workers to parse files concurrently.
				-- A value of 0 automatically assigns number based on CPU.
				-- Set to 1 if experiencing lag.
				concurrent = 0,
			},
			running = {
				-- Run tests concurrently when an adapter provides multiple commands to run.
				concurrent = true,
			},
			summary = {
				-- Enable/disable animation of icons.
				animated = true,
			},
		},
		config = function(_, opts)
			if opts.adapters then
				local adapters = {}
				for name, config in pairs(opts.adapters or {}) do
					if type(name) == "number" then
						if type(config) == "string" then
							config = require(config)
						end
						adapters[#adapters + 1] = config
					elseif config ~= false then
						local adapter = require(name)
						if type(config) == "table" and not vim.tbl_isempty(config) then
							local meta = getmetatable(adapter)
							if adapter.setup then
								adapter.setup(config)
							elseif adapter.adapter then
								adapter.adapter(config)
								adapter = adapter.adapter
							elseif meta and meta.__call then
								adapter(config)
							else
								error("Adapter " .. name .. " does not support setup")
							end
						end
						adapters[#adapters + 1] = adapter
					end
				end
				opts.adapters = adapters
			end

			-- Set up Neotest.
			require("neotest").setup(opts)

			-- enable logging
			local log = false
			if log == true then
				local filepath = require("neotest.logging"):get_filename()
				vim.notify("Erasing Neotest log file: " .. filepath, vim.log.levels.WARN)
				vim.fn.writefile({ "" }, filepath)

				-- Enable during Neotest adapter development only.
				local log_level = vim.log.levels.DEBUG
				vim.notify("Logging for Neotest enabled", vim.log.levels.WARN)
				require("neotest.logging"):set_level(log_level)
			end
		end,
		keys = {
			{
				"<leader>tt",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
					-- require("jdtls.dap").test_class({	})
				end,
				desc = "run test file",
			},
			{
				"<leader>to",
				"<CMD>Neotest output-panel<CR>",
				desc = "[t]est [o]utput panel",
			},
			{
				"<leader>ts",
				"<CMD>Neotest summary<CR>",
				desc = "[t]est [s]ummary panel",
			},
			{
				"<leader>tr",
				function()
					require("neotest").run.run()
				end,
				desc = "run nearest test",
			},
			{
				"<leader>tD",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "debug test file",
			},
			{
				"<leader>td",
				function()
					require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
				end,
				desc = "debug nearest test",
			},
		},
	},
}
