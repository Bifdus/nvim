return {
  {
    -- Mason for installing language servers
    "mason-org/mason.nvim",
    opts = {},
    config = function()
      require("mason").setup()

      -- Auto-install formatters and tools
      local ensure_installed = {
        "stylua", -- Lua
        "prettier", -- JS/TS/CSS/HTML/JSON/YAML/Markdown
        "eslint_d", -- JS/TS linting
        "black", -- Python
        "ruff", -- Python
        "isort", -- Python import sorting
        "shfmt", -- Shell scripts
      }

      local registry = require("mason-registry")
      registry.refresh(function()
        for _, tool in ipairs(ensure_installed) do
          local p = registry.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  {
    -- Useful status updates for LSP
    "j-hui/fidget.nvim",
    opts = {},
  },


}
