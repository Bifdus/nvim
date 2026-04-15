---@brief
--- https://github.com/astral-sh/ruff
--- Refer to the [documentation](https://docs.astral.sh/ruff/editors/) for more details.

local util = require("util.lsp")

---@type vim.lsp.Config
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_dir = util.root_dir_with_fallback({ "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" }),

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
