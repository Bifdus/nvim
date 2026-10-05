return {
  {
    -- Mason for installing language servers
    "mason-org/mason.nvim",
    opts = {},
  },

  {
    -- Useful status updates for LSP
    "j-hui/fidget.nvim",
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
      local names = Util.lsp
      require("mason-tool-installer").setup({
        ensure_installed = names.ensure_list(),
        run_on_start = true,
      })
    end,
  },
}
