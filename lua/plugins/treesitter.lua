return {
  -----------------------------------------------------------------------------
  -- Highlight, edit, navigate code
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPost",
    build = ":TSUpdate",
    dependencies = {
      "HiPhish/rainbow-delimiters.nvim",
      "folke/snacks.nvim",
    },
    main = "nvim-treesitter.configs",
    opts = {
      ignore_install = { "org" },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "ruby", "markdown" },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.install").prefer_git = true

      require("nvim-treesitter.configs").setup(opts)

      require("rainbow-delimiters.setup").setup({
        query = {
          [""] = "rainbow-delimiters",
          latex = "rainbow-blocks",
        },
      })
    end,
  },
}
