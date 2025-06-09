return {
  -----------------------------------------------------------------------------
  -- Comments, with context
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    ft = { "javascriptreact", "typescriptreact" },
    keys = {
      {
        "<Leader>V",
        "<Plug>(comment_toggle_blockwise_current)",
        mode = "n",
        desc = "Comment",
        ft = { "typescriptreact", "javascriptreact" },
      },
      {
        "<Leader>V",
        "<Plug>(comment_toggle_blockwise_visual)",
        mode = "x",
        desc = "Comment",
        ft = { "typescriptreact", "javascriptreact" },
      },
    },
    opts = function(_, opts)
      local ok, tcc = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      if ok then
        opts.pre_hook = tcc.create_pre_hook()
      end
    end,
  },
  {
    "stevearc/aerial.nvim",
    opts = {
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
    },
    config = function(_, opts)
      require("aerial").setup(opts)
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- Rest interface
  {
    "mistweaverco/kulala.nvim",
    keys = {
      { "<leader>Rs", desc = "Send request", ft = { "http", "rest" } },
      { "<leader>Ra", desc = "Send all requests", ft = { "http", "rest" } },
      { "<leader>Ro", desc = "Open scratchpad", ft = { "http", "rest" } },
    },
    ft = { "http", "rest", "html" },
    opts = {
      -- your configuration comes here
      global_keymaps = false,
    },
  },

  -----------------------------------------------------------------------------
  -- Quick log lines with smart variable identification, only python, lua and JS
  {
    "chrisgrieser/nvim-chainsaw",
    opts = {
      logStatements = {
        variableLog = {
          javascript = 'console.log("{{marker}} {{var}}:", {{var}});',
          nvim_lua = 'dd("{{var}}")',
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Lsp Saga
  {
    "nvimdev/lspsaga.nvim",
    event = { "LspAttach" },
    opts = {
      lightbulb = {
        enable = false,
        enable_in_insert = false,
        sign = false,
        sign_priority = 40,
        virtual_text = false,
      },
      finder = {
        max_height = 0.5,
        min_width = 30,
        force_max_height = false,
        keys = {
          jump_to = "p",
          expand_or_jump = "o",
          vsplit = "s",
          split = "i",
          tabe = "t",
          quit = { "q", "<ESC>" },
        },
      },
      definition = {
        edit = "<C-c>o",
        vsplit = "<C-c>v",
        split = "<C-c>i",
        tabe = "<C-c>t",
        quit = "q",
      },
      code_action = {
        num_shortcut = true,
        keys = {
          quit = "q",
          exec = "<CR>",
        },
      },
    },
    config = function(_, opts)
      require("lspsaga").setup(opts)
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
  },

  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
    opts = {},
  },

  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        FIX = {
          alt = { "FIX", "BUG", "ISSUE" },
        },
        WARN = { alt = { "WARNING" } },
        PERF = { alt = { "OPT", "OPTIMIZE" } },
      },
      highlight = {
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
        comments_only = true,
        max_line_len = 400,
        exclude = {},
      },
    },
  },

  -----------------------------------------------------------------------------
  -- LSP Diagnostics and quickfix
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},

    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<CR>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
        desc = "buffer Disagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<CR>",
        desc = "Symbols (Trouble)",
      },
      -- {
      --   '<leader>cl',
      --   '<cmd>Trouble lsp toggle focus=false win.position=right<CR>',
      --   desc = 'LSP Definitions / references / ... (Trouble)',
      -- },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<CR>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle <cr>",
        desc = "Quickfix list (Trouble)",
      },
    },
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup()
      vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
    end,
  },

  -----------------------------------------------------------------------------
  -- Mini
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    enabled = false,
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
      LazyVim.mini.pairs(opts)
    end,
  },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
          g = LazyVim.mini.ai_buffer, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      vim.schedule(function()
        LazyVim.mini.ai_whichkey(opts)
      end)
    end,
  },

  -----------------------------------------------------------------------------
  -- Perform diffs on blocks of code
  {
    "AndrewRadev/linediff.vim",
    cmd = { "Linediff", "LinediffAdd" },
    keys = {
      { "<leader>mdf", ":Linediff<CR>", mode = "x", desc = "Line diff" },
      { "<leader>mda", ":LinediffAdd<CR>", mode = "x", desc = "Line diff add" },
      { "<leader>mds", "<cmd>LinediffShow<CR>", desc = "Line diff show" },
      { "<leader>mdr", "<cmd>LinediffReset<CR>", desc = "Line diff reset" },
    },
  },

  -----------------------------------------------------------------------------
  -- Learning Section
  {
    "2kabhishek/exercism.nvim",
    cmd = {
      "ExercismLanguages",
      "ExercismList",
      "ExercismSubmit",
      "ExercismTest",
    },
    keys = {
      { "<leader>lxa", "<cmd>ExercismList<CR>", desc = "Exercism All exercises" },
      { "<leader>lxl", "<cmd>ExercismLanguages<CR>", desc = "Exercism Languages" },
      { "<leader>lxt", "<cmd>ExercismTest<CR>", desc = "ExercismTest" },
      { "<leader>lxs", "<cmd>ExercismSubmit<CR>", desc = "ExercismSubmit" },
    },
    dependencies = {
      {
        "2kabhishek/utils.nvim",
        opts = {
          fuzzy_provider = "snacks",
        },
      },
      "2kabhishek/termim.nvim", -- optional, better UX for running tests
    },
    -- Add your custom configs here, keep it blank for default configs (required)
    opts = {
      exercism_workspace = "~/exercism",
      default_language = "typescript",
      add_default_keybindings = false,
    },
    config = function(_, opts)
      require("exercism").setup(opts)
    end,
  },
  -----------------------------------------------------------------------------
  -- Leetcode Problems
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    cmd = "Leet",
    dependencies = {
      -- 'nvim-telescope/telescope.nvim',
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",
      -- "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- configuration goes here
      lang = "python3",
    },
  },
  {
    "roobert/f-string-toggle.nvim",
    config = function()
      require("f-string-toggle").setup({
        key_binding = "<leader>f",
        key_binding_desc = "Toggle f-string",
      })
    end,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
