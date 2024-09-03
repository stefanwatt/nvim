local function extend_or_override(config, custom, ...)
	if type(custom) == "function" then
		config = custom(config, ...) or config
	elseif custom then
		config = vim.tbl_deep_extend("force", config, custom) --[[@as table]]
	end
	return config
end

local java_filetypes = { "java" }

return {
	"mfussenegger/nvim-jdtls",
	dependencies = {
		"folke/which-key.nvim",
		{
			"nvim-neotest/neotest",
			opts = {
				adapters = {
					["neotest-java"] = {
						-- config here
					},
				},
			},
			dependencies = {
				"nvim-neotest/nvim-nio",
				"rcasia/neotest-java",
				"nvim-lua/plenary.nvim",
				"antoinemadec/FixCursorHold.nvim",
				"nvim-treesitter/nvim-treesitter",
			},
		},
	},
	ft = java_filetypes,
	opts = function()
		require("neotest").setup({
			adapters = {
				require("neotest-java")({
					ignore_wrapper = false,
					junit_jar = nil,
				}),
			},
		})
		local mason_registry = require("mason-registry")
		local lombok_jar = mason_registry.get_package("jdtls"):get_install_path() .. "/lombok.jar"
		return {
			root_dir = require("lspconfig.server_configurations.jdtls").default_config.root_dir,
			project_name = function(root_dir)
				return root_dir and vim.fs.basename(root_dir)
			end,
			jdtls_config_dir = function(project_name)
				return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
			end,
			jdtls_workspace_dir = function(project_name)
				return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
			end,
			cmd = {
				vim.fn.exepath("jdtls"),
				string.format("--jvm-arg=-javaagent:%s", lombok_jar),
			},
			full_cmd = function(opts)
				local fname = vim.api.nvim_buf_get_name(0)
				local root_dir = opts.root_dir(fname)
				local project_name = opts.project_name(root_dir)
				local cmd = vim.deepcopy(opts.cmd)
				if project_name then
					vim.list_extend(cmd, {
						"-configuration",
						opts.jdtls_config_dir(project_name),
						"-data",
						opts.jdtls_workspace_dir(project_name),
					})
				end
				return cmd
			end,
			dap = { hotcodereplace = "auto", config_overrides = {} },
			dap_main = {},
			test = true,
			settings = {
				java = {
					inlayHints = false
				},
			},
		}
	end,
	config = function(_, opts)
		local mason_registry = require("mason-registry")
		local bundles = {} ---@type string[]
		local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
		local java_dbg_path = java_dbg_pkg:get_install_path()
		local jar_patterns = {
			java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
		}
		if opts.test and mason_registry.is_installed("java-test") then
			local java_test_pkg = mason_registry.get_package("java-test")
			local java_test_path = java_test_pkg:get_install_path()
			vim.list_extend(jar_patterns, {
				java_test_path .. "/extension/server/*.jar",
			})
		end
		for _, jar_pattern in ipairs(jar_patterns) do
			for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
				table.insert(bundles, bundle)
			end
		end

		local function attach_jdtls()
			local fname = vim.api.nvim_buf_get_name(0)
			local config = extend_or_override({
				cmd = opts.full_cmd(opts),
				root_dir = opts.root_dir(fname),
				init_options = {
					bundles = bundles,
				},
				settings = opts.settings,
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			}, opts.jdtls)

			require("jdtls").start_or_attach(config)
		end
		vim.api.nvim_create_autocmd("FileType", {
			pattern = java_filetypes,
			callback = attach_jdtls,
		})
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.name == "jdtls" then
					local wk = require("which-key")
					wk.add({
						{
							mode = "n",
							buffer = args.buf,
							{ "<leader>cx",  group = "extract" },
							{ "<leader>cxv", require("jdtls").extract_variable_all, desc = "Extract Variable" },
							{ "<leader>cxc", require("jdtls").extract_constant,     desc = "Extract Constant" },
							{ "gs",          require("jdtls").super_implementation, desc = "Goto Super" },
							{ "gS",          require("jdtls.tests").goto_subjects,  desc = "Goto Subjects" },
							{ "<leader>co",  require("jdtls").organize_imports,     desc = "Organize Imports" },
						},
					})
					wk.add({
						{
							mode = "v",
							buffer = args.buf,
							{ "<leader>cx", group = "extract" },
							{
								"<leader>cxm",
								[[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
								desc = "Extract Method",
							},
							{
								"<leader>cxv",
								[[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
								desc = "Extract Variable",
							},
							{
								"<leader>cxc",
								[[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
								desc = "Extract Constant",
							},
						},
					})
					require("jdtls").setup_dap(opts.dap)
					-- require("jdtls.dap").setup_dap_main_class_configs(opts.dap_main)
				end
			end,
		})
		attach_jdtls()
	end,
}
