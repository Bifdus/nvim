-- lua/lsp/_caps.lua
local M = {}

function M.make()
  local base = vim.lsp.protocol.make_client_capabilities()

  local ok, cmp = pcall(require, "cmp_nvim_lsp")
  local caps = ok and cmp.default_capabilities(base) or base
  -- local ok, blink = pcall(require, "blink.cmp")
  -- local caps = base
  -- if ok and type(blink) == "table" and type(blink.get_lsp_capabilities) == "function" then
  --   caps = blink.get_lsp_capabilities(base)
  -- end

  caps.workspace = caps.workspace or {}
  caps.workspace.fileOperations =
    vim.tbl_deep_extend("force", caps.workspace.fileOperations or {}, { didRename = true, willRename = true })

  return caps
end

return M
