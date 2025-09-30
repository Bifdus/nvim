-- TODO: Make this re-useable
local M = {}

M.ignore_codes = {
  [6133] = true, -- declared but its value is never read
  [7027] = true, -- unreachable code detected
  [7029] = true, -- fallthrough case in switch
}

function M.filter_diagnostic_overlap()
  local orig = vim.lsp.handlers["textDocument/publishDiagnostics"]
  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, cfg)
    local client = ctx and vim.lsp.get_client_by_id(ctx.client_id)
    if client and (client.name == "vtsls" or client.name == "tsserver") then
      if result and result.diagnostics then
        local filtered = {}
        for _, d in ipairs(result.diagnostics) do
          if not M.ignore_codes[tonumber(d.code)] then
            table.insert(filtered, d)
          end
        end
        result = vim.tbl_extend("force", result, { diagnostics = filtered })
      end
    end
    return orig(err, result, ctx, cfg)
  end
end

return M
