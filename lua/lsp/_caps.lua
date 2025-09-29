-- lua/lsp/_caps.lua
local M = {}

function M.make()
  -- Base client caps from Neovim
  local base = vim.lsp.protocol.make_client_capabilities()

  -- Try to add nvim-cmp’s advertised capabilities
  local ok, cmp = pcall(require, "cmp_nvim_lsp")
  local caps = ok and cmp.default_capabilities(base) or base

  caps.workspace = caps.workspace or {}
  caps.workspace.fileOperations = vim.tbl_deep_extend("force",
    caps.workspace.fileOperations or {},
    { didRename = true, willRename = true }
  )

  return caps
end

return M
