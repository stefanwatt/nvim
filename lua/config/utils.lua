local M = {}

M.getSubDirectories = function (dirname)
  local dir = io.popen('ls ' .. dirname)
  local subdirectories = {}
  for name in dir:lines() do table.insert(subdirectories,name) end
  return subdirectories
end

return M
