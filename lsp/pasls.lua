local util = require("util.lsp")

---@type vim.lsp.Config
return {
  cmd = { "pasls" },
  filetypes = { "pascal" },
  root_dir = util.root_dir_with_fallback({ ".git" }),
}
