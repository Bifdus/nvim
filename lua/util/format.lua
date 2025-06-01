local M = {}

-- Use buf as a boolean flag: true for buffer-local, false (or nil) for global.
-- For buffer-local, we use the current buffer's id.
---@param buf? boolean
function M.enabled(buf)
  if buf then
    local current_buf = vim.api.nvim_get_current_buf()
    local baf = vim.b[current_buf].autoformat
    if baf ~= nil then
      return baf
    end
    -- If not set, you might want to define a default for buffer-local autoformat,
    -- or fall back to the global value.
    return vim.g.autoformat == nil or vim.g.autoformat
  else
    return vim.g.autoformat == nil or vim.g.autoformat
  end
end

---@param buf? boolean
function M.toggle(buf)
  M.enable(not M.enabled(buf), buf)
end

---@param enable? boolean
---@param buf? boolean
function M.enable(enable, buf)
  if enable == nil then
    enable = true
  end
  if buf then
    local current_buf = vim.api.nvim_get_current_buf()
    vim.b[current_buf].autoformat = enable
  else
    vim.g.autoformat = enable
    -- Clear any buffer-local override
    local current_buf = vim.api.nvim_get_current_buf()
    vim.b[current_buf].autoformat = nil
  end
  -- Optionally, provide feedback here (implement M.info if needed)
  -- M.info()
end

---@param buf? boolean
function M.snacks_toggle(buf)
  return Snacks.toggle {
    name = 'Auto Format (' .. (buf and 'Buffer' or 'Global') .. ')',
    get = function()
      return M.enabled(buf)
    end,
    set = function(state)
      M.enable(state, buf)
    end,
  }
end

return M
