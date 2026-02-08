local M = {}

---@class pleat.Opts
---
--- The character to fill the fold text with.
---@field fill_char? string
---
--- The character to show between the opening and ending lines in the fold.
---@field collapsed_char? string
---
--- The file types to omit the fold end part of the fold text.
---@field foldend_exclude_filetypes? string[]
local defaults = {
  fill_char = " ",
  collapsed_char = "…",
  foldend_exclude_filetypes = {
    "markdown",
    "python",
    "toml",
    "yaml",
  },
}

---@type pleat.Opts|nil
vim.g.pleat_opts = vim.g.pleat_opts

M.opts = vim.tbl_deep_extend("force", vim.deepcopy(defaults), vim.g.pleat_opts or {})

---@param str string
---@return string
function M.expand_starting_spaces(str)
  str = str:gsub("\t", string.rep(" ", vim.bo.tabstop))

  local spaces = str:match "^%s%s+"

  if spaces then
    str = str:gsub(spaces, M.opts.fill_char:rep(#spaces - 1) .. " ", 1)
  end

  return str
end

---@param str string
---@return string
function M.expand_spaces(str)
  for spaces in str:gmatch "%s%s%s+" do
    str = str:gsub(spaces, M.opts.fill_char:rep(#spaces - 1) .. " ", 1)
  end

  return str
end

---@return string
function M.get()
  local ret = {
    M.expand_starting_spaces(vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1]),
    M.opts.collapsed_char,
  }

  if not vim.tbl_contains(M.opts.foldend_exclude_filetypes, vim.bo.filetype) then
    local line = vim.api.nvim_buf_get_lines(0, vim.v.foldend - 1, vim.v.foldend, true)[1]:match "^%s*(.-)%s*$"
    table.insert(ret, line)
  end

  table.insert(ret, "")

  return M.expand_spaces(table.concat(ret, " "))
end

return M
