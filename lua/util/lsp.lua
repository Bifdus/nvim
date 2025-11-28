local M = {}

M.lsp_to_mason = {
  lua_ls = "lua-language-server",
  vtsls = "vtsls",
  basedpyright = "basedpyright",
  yamlls = "yaml-language-server",
  clangd = "clangd",
  ruff = "ruff"
}

M.extra_tools = {
  "eslint_d",
  "prettier",
  "stylua",
  "shfmt",
  "ruff",
  "black",
  "isort",
}

function M.ensure_list()
  local list = {}
  for _, mason_name in pairs(M.lsp_to_mason) do
    table.insert(list, mason_name)
  end
  for _, t in ipairs(M.extra_tools) do
    table.insert(list, t)
  end
  return list
end

return M
