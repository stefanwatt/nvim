return {
	"L3MON4D3/LuaSnip",
	event = "VeryLazy",
	build = (not jit.os:find("Windows"))
			and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
		or nil,
	dependencies = {
		"rafamadriz/friendly-snippets",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			local ls = require("luasnip")
			local i = ls.insert_node
			local t = ls.text_node
			ls.add_snippets("svelte", {
				ls.snippet("sts", {
					t({ '<script lang="ts">', "\t" }),
					i(1, ""),
					t({ "", "</script>" }),
				}),
			})
		end,
	},
	opts = {
		history = true,
		delete_check_events = "TextChanged",
	},
  -- stylua: ignore
  keys = {
    {
      "<tab>",
      function()
        return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
      end,
      expr = true, silent = true, mode = "i",
    },
    { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
    { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
  },
}
