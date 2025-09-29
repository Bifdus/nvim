-- lua/lsp/init.lua
local have_nerd = vim.g.have_nerd_font

vim.lsp.config("*", require("lsp._defaults")) -- extends onto every server. 0.11+ API

vim.diagnostic.config({
  underline = false,
  update_in_insert = false,
  severity_sort = true,
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(d)
      local by_sev = {
        [vim.diagnostic.severity.ERROR] = d.message,
        [vim.diagnostic.severity.WARN] = d.message,
        [vim.diagnostic.severity.INFO] = d.message,
        [vim.diagnostic.severity.HINT] = d.message,
      }
      return by_sev[d.severity]
    end,
  },
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

-- 3) Enable inlay hints on LSP attach if server supports it
--    (guard + slight defer to dodge known race conditions)
local aug = vim.api.nvim_create_augroup("LspInlayHints", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = aug,
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.server_capabilities and client.server_capabilities.inlayHintProvider then
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_loaded(ev.buf) then
          pcall(vim.lsp.inlay_hint.enable, true, { bufnr = ev.buf })
        end
      end, 150)
    end
  end,
})

local servers = { "lua_ls", "vtsls" }

for _, name in ipairs(servers) do
  local ok, cfg = pcall(require, "lsp." .. name)
  if ok and type(cfg) == "table" then
    -- Extends *
    vim.lsp.config[name] = cfg
    vim.lsp.enable(name)
  end
end

