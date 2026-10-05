local M = {}

---@type table<number, string>
local cache = {}

-- Nearest ancestor containing .git or lua/, else cwd. Cached per buffer.
function M.get()
  local buf = vim.api.nvim_get_current_buf()
  cache[buf] = cache[buf] or vim.fs.root(buf, { ".git", "lua" }) or vim.uv.cwd()
  return cache[buf]
end

function M.cwd()
  return vim.uv.cwd()
end

return M
