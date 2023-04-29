return {
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependenies = {
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'rafamadriz/friendly-snippets' },
      { 'L3MON4D3/LuaSnip' },
    },
    config = function()
      require('lsp-zero.cmp').extend()
      local cmp = require('cmp')
      local cmp_action = require('lsp-zero.cmp').action()

      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        sources = {
          { name = 'path' },
          { name = 'nvim_lsp' },
          { name = 'buffer',  keyword_length = 3 },
          { name = 'luasnip', keyword_length = 2 },
        },
        mapping = {
          ['<Tab>'] = cmp_action.luasnip_jump_forward(),
          ['<S-Tab>'] = cmp_action.luasnip_jump_backward(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, _vim_item)
            local vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, _vim_item)
            local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"
            return kind
          end
        },
      })
    end
  }
}
