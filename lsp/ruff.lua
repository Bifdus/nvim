---@brief
--- https://github.com/astral-sh/ruff
--- Refer to the [documentation](https://docs.astral.sh/ruff/editors/) for more details.

---@type vim.lsp.Config
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },

  init_options = {
    settings = {
      lint = {
        ignore = {
          "E401",
        },
      },
    },
  },
  -- settings = {},
}
