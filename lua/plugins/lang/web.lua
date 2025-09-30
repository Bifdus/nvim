return {
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "css", "javascript", "typescript", "typescriptreact", "javascriptreact" },
    event = "VeryLazy",
    opts = {},
  },

  { "nvchad/volt", lazy = false },
  {
    "nvchad/minty",
    opts = { filetypes = { "css", "html", "typescript", "javascript", "tsx", "ts", "jsx" } },
    config = function(_, opts)
      require("minty").setup(opts)
    end,
  },
}
