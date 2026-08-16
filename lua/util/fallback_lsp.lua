local M = {}

local function has_lsp_method(method)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.supports_method and client:supports_method(method) then
      return true
    end
  end
  return false
end

local function word()
  return vim.fn.expand("<cword>")
end

local function snacks_picker()
  local ok, Snacks = pcall(require, "snacks")
  if ok and Snacks.picker then
    return Snacks.picker
  end
end

function M.definition()
  if has_lsp_method("textDocument/definition") then
    return vim.lsp.buf.definition()
  end
  vim.cmd("normal! <C-]>")
end

function M.declaration()
  if has_lsp_method("textDocument/declaration") then
    return vim.lsp.buf.declaration()
  end
  vim.cmd("tselect " .. vim.fn.fnameescape(word()))
end

function M.references()
  if has_lsp_method("textDocument/references") then
    return vim.lsp.buf.references()
  end

  local picker = snacks_picker()
  if picker then
    return picker.grep({ search = word() })
  end

  vim.cmd("grep! " .. vim.fn.shellescape(word()) .. " .")
  vim.cmd("copen")
end

function M.implementation()
  if has_lsp_method("textDocument/implementation") then
    return vim.lsp.buf.implementation()
  end

  local picker = snacks_picker()
  if picker then
    return picker.grep({ search = word() })
  end

  vim.cmd("tselect " .. vim.fn.fnameescape(word()))
end

function M.document_symbols()
  if has_lsp_method("textDocument/documentSymbol") then
    return vim.lsp.buf.document_symbol()
  end

  local picker = snacks_picker()
  if picker then
    return picker.lines({ search = word() })
  end

  vim.notify("No document symbol fallback available", vim.log.levels.WARN)
end

function M.workspace_symbols()
  if has_lsp_method("workspace/symbol") then
    return vim.lsp.buf.workspace_symbol(word())
  end

  local picker = snacks_picker()
  if picker then
    return picker.grep({ search = word() })
  end

  vim.cmd("grep! " .. vim.fn.shellescape(word()) .. " .")
  vim.cmd("copen")
end

function M.hover()
  if has_lsp_method("textDocument/hover") then
    return vim.lsp.buf.hover()
  end

  local picker = snacks_picker()
  if picker then
    return picker.grep({ search = word() })
  end

  vim.notify("No hover available", vim.log.levels.INFO)
end

return M
