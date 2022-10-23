local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup({
  ensure_installed = "all", -- one of "all" or a list of languages
  ignore_install = { "" }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "css" }, -- list of language that will be disabled
  },
  autopairs = {
    enable = true,
  },
  autotag = {
    enable = true,
    filetypes = { "html", "svelte" },
  },
  indent = { enable = true, disable = { "python", "css" } },

  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    colors = {
      '#ED8796',
      '#A6DA95',
      '#EED49F',
      '#8AADF4',
      '#F5BDE6',
      '#8BD5CA',
      '#B8C0E0',
    }, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
})
