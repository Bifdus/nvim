-- lua/Core/lsp/init.lua
local M = {}

-- --- On-attach registry (like LazyVim’s)
local _attach = {}
function M.on_attach(fn)
  _attach[#_attach + 1] = fn
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("core.lsp.attach", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    for _, fn in ipairs(_attach) do
      local ok, err = pcall(fn, client, ev.buf)
      if not ok and err then
        vim.schedule(function()
          vim.notify(string.format("core.lsp.on_attach error: %s", err), vim.log.levels.ERROR)
        end)
      end
    end
  end,
})

M.action = setmetatable({}, {
  __index = function(_, kind)
    local kinds = { kind }
    local prefix = kind:match("^(.*)%.[^%.]+$")
    if prefix and prefix ~= kind then
      table.insert(kinds, prefix)
    end

    return function(bufnr)
      vim.lsp.buf.code_action({
        apply = true,
        context = { only = kinds, diagnostics = {} },
      }, bufnr)
    end
  end,
})

function M.execute(cmd)
  -- supports {command=..., arguments=..., open=?}
  if type(cmd) == "table" and cmd.command then
    vim.lsp.buf.execute_command(cmd)
  end
end

return M
