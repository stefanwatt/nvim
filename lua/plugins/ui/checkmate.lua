return {
	"bngarren/checkmate.nvim",
	ft = "markdown",
	opts = {
		-- checkmate.Config
		todo_states = {
			unchecked = {
				marker = "[ ]",
			},
			checked = {
				marker = "[x]",
			}
		},
		style = false,
		files = { "*.md" },
		metadata = {
			planned = {
				on_add = function(todo)
					-- Strip list marker, todo marker, and @metadata tags to get clean title
					local text = todo.text
					text = text:gsub("^%s*[%-%*%+]%s+", "") -- strip list marker
					text = text:gsub("^.-%s+", "", 1)  -- strip todo marker
					text = text:gsub("%s*@%w+[^%s]*", "") -- strip @metadata tags
					local bucket = vim.trim(text)

					local valid_labels = { MaCIP = true, ["MedCo-U"] = true, ["Rule-Engine"] = true, Grouper = true }

					local _, label = todo.get_metadata("label")
					if not label then
						local filepath = vim.api.nvim_buf_get_name(0)
						local docs_dir = vim.fn.expand("~/Documents/")
						local subdir = filepath:match("^" .. vim.pesc(docs_dir) .. "([^/]+)/")
						if subdir and valid_labels[subdir] then
							label = subdir
						end
					end

					local cmd = {
						"bun",
						"/home/stefan/Projects/ms-teams-planner/main.ts",
						bucket,
					}
					if label then
						table.insert(cmd, label)
					end
					vim.fn.jobstart(cmd, {
						cwd = "/home/stefan/Projects/ms-teams-planner",
						on_exit = function(_, code)
							if code == 0 then
								vim.notify("📋 Task added to MS Teams Planner", vim.log.levels.INFO)
							else
								vim.notify("❌ Failed to add task to MS Teams Planner", vim.log.levels.ERROR)
							end
						end,
					})
				end,
			},
			label = {
				key = "<leader>Tl",
				get_value = function()
					local valid_labels = { MaCIP = true, ["MedCo-U"] = true, ["Rule-Engine"] = true, Grouper = true }
					local filepath = vim.api.nvim_buf_get_name(0)
					local docs_dir = vim.fn.expand("~/Documents/")
					local subdir = filepath:match("^" .. vim.pesc(docs_dir) .. "([^/]+)/")
					return (subdir and valid_labels[subdir]) and subdir or ""
				end,
				choices = { "MaCIP", "MedCo-U", "Rule-Engine", "Grouper" },
			},
		},
	},
}
