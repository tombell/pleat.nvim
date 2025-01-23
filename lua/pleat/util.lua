local Config = require "pleat.config"

local M = {}

---@param str string
---@return string
function M.expand_starting_spaces(str)
  str = str:gsub("\t", string.rep(" ", vim.bo.tabstop))

  local spaces = str:match "^%s%s+"

  if spaces then
    str = str:gsub(spaces, Config.fill_char:rep(#spaces - 1) .. " ", 1)
  end

  return str
end

---@param str string
---@return string
function M.expand_spaces(str)
  for spaces in str:gmatch "%s%s%s+" do
    str = str:gsub(spaces, Config.fill_char:rep(#spaces - 1) .. " ", 1)
  end

  return str
end

return M
