return {
  { -- Autocompletion
    "saghen/blink.cmp",
    enabled = false,
    event = "VimEnter",
    version = "1.*",
    dependencies = {
      -- Snippet Engine
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
        opts = {},
      },
      "folke/lazydev.nvim",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<Up>"] = {},
        ["<Down>"] = {},
      },
      snippets = { preset = "luasnip" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        accept = {
          auto_brackets = {
            enabled = true,
          },
          menu = {
            draw = {
              treesitter = { "lsp" },
            },
          },
        },
      },

      appearance = {
        nerd_font_variant = "mono",
        kind_icons = Util.icons.kinds,
      },

      sources = {
        default = { "lsp", "path", "snippets", "lazydev" },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = false },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
