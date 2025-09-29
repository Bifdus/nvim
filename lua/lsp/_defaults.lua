local caps = require("lsp._caps").make()

return {
  capabilities = caps,

  inlay_hints = { enabled = true },
}
