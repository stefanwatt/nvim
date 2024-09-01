return {
	"MagicDuck/grug-far.nvim",
	keys = {
		{
			"<leader>R",
			function()
				require("grug-far").open()
			end,
		},
		{
			"<leader>R",
			mode = { "v", "x" },
			function()
				require("grug-far").with_visual_selection()
			end,
		},
	},
	config = function()
		require("grug-far").setup({
			debounceMs = 500,
			minSearchChars = 2,
			maxSearchMatches = 2000,
			maxWorkers = 8,
			engines = {
				ripgrep = {
					extraArgs = "",

					-- placeholders to show in input areas when they are empty
					-- set individual ones to '' to disable, or set enabled = false for complete disable
					placeholders = {
						-- whether to show placeholders
						enabled = true,

						search = "ex: foo    foo([a-z0-9]*)    fun\\(",
						replacement = "ex: bar    ${1}_foo    $$MY_ENV_VAR ",
						filesFilter = "ex: *.lua     *.{css,js}    **/docs/*.md",
						flags = "ex: --help --ignore-case (-i) --replace= (empty replace) --multiline (-U)",
						paths = "ex: /foo/bar   ../   ./hello\\ world/   ./src/foo.lua",
					},
				},
				-- see https://ast-grep.github.io
				astgrep = {
					-- ast-grep executable to use, can be a different path if you need to configure
					path = "sg",

					-- extra args that you always want to pass
					-- like for example if you always want context lines around matches
					extraArgs = "",

					-- placeholders to show in input areas when they are empty
					-- set individual ones to '' to disable, or set enabled = false for complete disable
					placeholders = {
						-- whether to show placeholders
						enabled = true,

						search = "ex: $A && $A()   foo.bar($$$ARGS)   $_FUNC($_FUNC)",
						replacement = "ex: $A?.()   blah($$$ARGS)",
						filesFilter = "ex: *.lua   *.{css,js}   **/docs/*.md   (filters via ripgrep)",
						flags = "ex: --help (-h) --debug-query=ast --rewrite= (empty replace) --strictness=<STRICTNESS>",
						paths = "ex: /foo/bar  ../  ./hello\\ world/  ./src/foo.lua",
					},
				},
			},

			-- search and replace engine to use.
			-- Must be one of 'ripgrep' | 'astgrep' | nil
			-- if nil, defaults to 'ripgrep'
			engine = "ripgrep",

			-- specifies the command to run (with `vim.cmd(...)`) in order to create
			-- the window in which the grug-far buffer will appear
			-- ex (horizontal bottom right split): 'botright split'
			-- ex (open new tab): 'tabnew %'
			windowCreationCommand = "vsplit",

			-- buffer line numbers + match line numbers can get a bit visually overwhelming
			-- turn this off if you still like to see the line numbers
			disableBufferLineNumbers = true,

			-- maximum number of search chars to show in buffer and quickfix list titles
			-- zero disables showing it
			maxSearchCharsInTitles = 30,

			-- static title to use for grug-far buffer, as opposed to the dynamically generated title.
			-- Note that nvim does not allow multiple buffers with the same name, so this option is meant more
			-- as something to be speficied for a particular instance as opposed to something set in the setup function
			-- nil or '' disables it
			staticTitle = nil,

			-- whether to start in insert mode,
			-- set to false for normal mode
			startInInsertMode = true,

			-- row in the window to position the cursor at at start
			startCursorRow = 3,

			-- whether to wrap text in the grug-far buffer
			wrap = true,

			-- whether or not to make a transient buffer which is both unlisted and fully deletes itself when not in use
			transient = false,

			-- by default, in visual mode, the visual selection is used to prefill the search
			-- setting this option to true disables that behaviour
			ignoreVisualSelection = false,

			-- shortcuts for the actions you see at the top of the buffer
			-- set to '' or false to unset. Mappings with no normal mode value will be removed from the help header
			-- you can specify either a string which is then used as the mapping for both normal and insert mode
			-- or you can specify a table of the form { [mode] = <lhs> } (ex: { i = '<C-enter>', n = '<leader>gr'})
			-- it is recommended to use <leader> though as that is more vim-ish
			-- see https://learnvimscriptthehardway.stevelosh.com/chapters/11.html#local-leader
			keymaps = {
				replace = { n = "<CR>" },
				qflist = { n = "<leader>q" },
				syncLocations = { n = "<leader>s" },
				syncLine = { n = "<leader>l" },
				close = { n = "q" },
				historyOpen = { n = "<leader>t" },
				historyAdd = { n = "<leader>a" },
				refresh = { n = "<leader>f" },
				openLocation = { n = "<leader>o" },
				openNextLocation = { i = "<C-n>",  n = "<C-n>"  },
				openPrevLocation = { i = "<C-n>",  n = "<C-n>"  },
				gotoLocation = { n = "<A-CR>" },
				pickHistoryEntry = { n = "<A-CR>" },
				abort = { n = "<leader>b" },
				help = { n = "?" },
				toggleShowCommand = { n = "<leader>p" },
				swapEngine = { n = "<leader>e" },
			},

			-- separator between inputs and results, default depends on nerdfont
			resultsSeparatorLineChar = "",

			-- highlight the results with TreeSitter, if available
			resultsHighlight = true,

			-- spinner states, default depends on nerdfont, set to false to disable
			spinnerStates = {
				"󱑋 ",
				"󱑌 ",
				"󱑍 ",
				"󱑎 ",
				"󱑏 ",
				"󱑐 ",
				"󱑑 ",
				"󱑒 ",
				"󱑓 ",
				"󱑔 ",
				"󱑕 ",
				"󱑖 ",
			},

			-- whether to report duration of replace/sync operations
			reportDuration = true,

			-- icons for UI, default ones depend on nerdfont
			-- set individual ones to '' to disable, or set enabled = false for complete disable
			icons = {
				-- whether to show icons
				enabled = true,

				actionEntryBullet = " ",

				searchInput = " ",
				replaceInput = " ",
				filesFilterInput = " ",
				flagsInput = "󰮚 ",
				pathsInput = " ",

				resultsStatusReady = "󱩾 ",
				resultsStatusError = " ",
				resultsStatusSuccess = "󰗡 ",
				resultsActionMessage = "  ",
				resultsEngineLeft = "⟪",
				resultsEngineRight = "⟫",
				resultsChangeIndicator = "┃",
				resultsAddedIndicator = "▒",
				resultsRemovedIndicator = "▒",
				resultsDiffSeparatorIndicator = "┊",
				historyTitle = "   ",
				helpTitle = " 󰘥  ",
			},

			-- strings to auto-fill in each input area at start
			-- those are not necessarily useful as global defaults but quite useful as overrides
			-- when launching through the lua API. For example, this is how you would launch grug-far.nvim
			-- with the current word under the cursor as the search string
			--
			-- require('grug-far').open({ prefills = { search = vim.fn.expand("<cword>") } })
			--
			prefills = {
				search = "",
				replacement = "",
				filesFilter = "",
				flags = "",
				paths = "",
			},

			-- search history settings
			history = {
				-- maximum number of lines in history file, end of file will be smartly truncated
				-- to remove oldest entries
				maxHistoryLines = 10000,

				-- directory where to store history file
				historyDir = vim.fn.stdpath("state") .. "/grug-far",

				-- configuration for when to auto-save history entries
				autoSave = {
					-- whether to auto-save at all, trumps all other settings below
					enabled = true,

					-- auto-save after a replace
					onReplace = true,

					-- auto-save after sync all
					onSyncAll = true,

					-- auto-save after buffer is deleted
					onBufDelete = true,
				},
			},

			-- unique instance name. This is used as a handle to refer to a particular instance of grug-far when
			-- toggling visibility, etc.
			-- As this needs to be unique per instance, this option is meant to be speficied for a particular instance
			-- as opposed to something set in the setup function
			instanceName = nil,

			-- folding related options
			folding = {
				-- whether to enable folding
				enabled = true,

				-- sets foldlevel, folds with higher level will be closed.
				-- result matche lines for each file have fold level 1
				-- set it to 0 if you would like to have the results initially collapsed
				-- See :h foldlevel
				foldlevel = 1,

				-- visual indicator of folds, see :h foldcolumn
				-- set to '0' to disable
				foldcolumn = "1",
			},

			-- options related to locations in results list
			resultLocation = {
				-- whether to show the result location number label
				-- this can be useful for example if you would like to use that number
				-- as a count to goto directly to a result
				-- (for instance `3<enter>` would goto the third result's location)
				showNumberLabel = true,

				-- position of the number when visible, acceptable values are:
				-- 'right_align', 'eol' and 'inline'
				numberLabelPosition = "right_align",

				-- format for the number label, by default it displays as for example:  [42]
				numberLabelFormat = " [%d]",
			},
		})
	end,
}
