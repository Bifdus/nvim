-- lua/lsp/init.lua
local have_nerd = vim.g.have_nerd_font
local defaults = require("lsp._defaults")
vim.lsp.config("*", defaults) -- extends onto every server configured

vim.diagnostic.config({
  underline = false,
  update_in_insert = false,
  severity_sort = true,
  -- TODO: handled by tiny diagnostic inlay hints, need to decide what's best
  -- virtual_text = {
  --   source = "if_many",
  --   spacing = 2,
  --   format = function(d)
  --     local by_sev = {
  --       [vim.diagnostic.severity.ERROR] = d.message,
  --       [vim.diagnostic.severity.WARN] = d.message,
  --       [vim.diagnostic.severity.INFO] = d.message,
  --       [vim.diagnostic.severity.HINT] = d.message,
  --     }
  --     return by_sev[d.severity]
  --   end,
  -- },
  signs = have_nerd and {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  } or {},
  float = { border = "rounded", source = "if_many" },
})
local servers = { "lua_ls", "vtsls", "basedpyright", "ruff", "clangd", "tailwind" }

require("lsp.ts_filter").filter_diagnostic_overlap()

for _, name in ipairs(servers) do
  -- vim.lsp.enable("lua_ls") searches runtime path lsp/lua_ls.lua
  -- which returns the config table
  vim.lsp.enable(name)
end
