local Config = require "pleat.config"
local Util = require "pleat.util"

local M = {}

---@param opts? pleat.Config
function M.setup(opts)
  require("pleat.config").setup(opts)
end

---@return string
function M.get()
  local ret = {
    Util.expand_starting_spaces(vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1]),
    Config.collapsed_char,
  }

  if not vim.tbl_contains(Config.foldend_exclude_filetypes, vim.bo.filetype) then
    local line = vim.api.nvim_buf_get_lines(0, vim.v.foldend - 1, vim.v.foldend, true)[1]:match "^%s*(.-)%s*$"
    table.insert(ret, line)
  end

  table.insert(ret, "")

  return Util.expand_spaces(table.concat(ret, " "))
end

return M
