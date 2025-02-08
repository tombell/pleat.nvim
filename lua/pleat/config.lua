---@class pleat.Config.mod: pleat.Config
local M = {}

---@class pleat.Config
---@field fill_char string
---@field collapsed_char string
---@field foldend_exclude_filetypes string[]
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

---@type pleat.Config
local options

---@param opts? pleat.Config
function M.setup(opts)
  ---@type pleat.Config
  options = vim.tbl_deep_extend("force", {}, options or defaults, opts or {})

  return options
end

return setmetatable(M, {
  __index = function(_, key)
    options = options or M.setup()
    return options[key]
  end,
})
