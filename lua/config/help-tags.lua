local M = {}

---@class HelpTag
---@field tag string       -- The help tag name
---@field filename string  -- The help file name (without path)
---@field filepath string  -- Full path to the help file
---@field cmd string      -- The vim command to jump to this tag
---@field lang string     -- The language of this tag

---Get all help tags from Neovim's runtime path
---@param opts? {lang?: string, fallback?: boolean} Configuration options
---   - lang: Language(s) to include, defaults to vim.o.helplang
---   - fallback: Whether to fallback to English if lang not found, defaults to true
---@return HelpTag[] tags List of help tags
function M.get_help_tags(opts)
  opts = opts or {}
  opts.lang = opts.lang or vim.o.helplang
  opts.fallback = opts.fallback ~= false

  -- Process languages
  local langs = vim.split(opts.lang, ",")
  if opts.fallback and not vim.tbl_contains(langs, "en") then
    table.insert(langs, "en")
  end
  local langs_map = {}
  for _, lang in ipairs(langs) do
    langs_map[lang] = true
  end

  -- Get runtime paths including lazy.nvim paths if available
  local rtp = vim.o.runtimepath
  local lazy = package.loaded["lazy.core.util"]
  if lazy and lazy.get_unloaded_rtp then
    local paths = lazy.get_unloaded_rtp("")
    rtp = rtp .. "," .. table.concat(paths, ",")
  end

  -- Find all doc files
  ---@type string[]
  local all_files = vim.fn.globpath(rtp, "doc/*", 1, 1)

  -- Separate help files and tag files
  local help_files = {}
  local tag_files = {}

  for _, fullpath in ipairs(all_files) do
    local filename = vim.fn.fnamemodify(fullpath, ":t")
    if filename == "tags" then
      if tag_files["en"] then
        table.insert(tag_files["en"], fullpath)
      else
        tag_files["en"] = { fullpath }
      end
    elseif filename:match("^tags%-..$") then
      local lang = filename:sub(-2)
      if langs_map[lang] then
        if tag_files[lang] then
          table.insert(tag_files[lang], fullpath)
        else
          tag_files[lang] = { fullpath }
        end
      end
    else
      help_files[filename] = fullpath
    end
  end

  -- Process tags
  local tags = {}
  local tags_map = {}   -- To prevent duplicates

  for _, lang in ipairs(langs) do
    for _, file in ipairs(tag_files[lang] or {}) do
      local lines = vim.fn.readfile(file)
      for _, line in ipairs(lines) do
        if not line:match("^!_TAG_") then
          local fields = vim.split(line, string.char(9))
          if #fields == 3 and not tags_map[fields[1]] then
            table.insert(tags, {
              tag = fields[1],
              filename = fields[2],
              filepath = help_files[fields[2]],
              cmd = fields[3],
              lang = lang
            })
            tags_map[fields[1]] = true
          end
        end
      end
    end
  end

  return tags
end

---Format a help tag entry for display
---@param tag HelpTag The help tag to format
---@param opts? {width?: number} Formatting options
---   - width: Minimum width for tag column alignment, defaults to 40
---@return string formatted The formatted string
function M.format_tag(tag, opts)
  opts = opts or {}
  local width = opts.width or 40
  -- Ensure minimum width while accounting for wide characters
  local tag_width = width + string.len(tag.tag) - vim.fn.strwidth(tag.tag)
  return string.format("%-" .. tag_width .. "s %s", tag.tag, tag.filename)
end

return M
