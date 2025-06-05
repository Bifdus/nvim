return {
  --
  {
    "mikavilpas/yazi.nvim",
    cmd = "Yazi",
    -- event = 'VeryLazy',
    keys = {
      {
        "\\",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "|",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        -- NOTE: this requires a version of yazi that includes
        -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
        "<leader>cr",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = true,
      keymaps = {
        show_help = "<f1>",
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = LazyVim.icons

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },

          lualine_c = {
            LazyVim.lualine.root_dir(),
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { LazyVim.lualine.pretty_path() },
          },
          lualine_x = {
            Snacks.profiler.status(),
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = function() return { fg = Snacks.util.color("Statement") } end,
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = function() return { fg = Snacks.util.color("Constant") } end,
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = function() return { fg = Snacks.util.color("Debug") } end,
            },
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return { fg = Snacks.util.color("Special") } end,
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "neo-tree", "lazy", "fzf" },
      }

      -- do not add trouble symbols if aerial is enabled
      -- And allow it to be overriden for some buffer types (see autocmds)
      if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
        local trouble = require("trouble")
        local symbols = trouble.statusline({
          mode = "symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "{kind_icon}{symbol.name:Normal}",
          hl_group = "lualine_c_normal",
        })
        table.insert(opts.sections.lualine_c, {
          symbols and symbols.get,
          cond = function()
            return vim.b.trouble_lualine ~= false and symbols.has()
          end,
        })
      end

      return opts
    end,
  },

  -----------------------------------------------------------------------------
  -- Folds
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup({
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              { text = { "%s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          })
        end,
      },
    },
	   --stylua: ignore
	   keys = {
	     { "zc" },
	     { "zo" },
	     { "zC" },
	     { "zO" },
	     { "za" },
	     { "zA" },
	     { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open Folds Except Kinds", },
	     { "zR", function() require("ufo").openAllFolds() end, desc = "Open All Folds", },
	     { "zM", function() require("ufo").closeAllFolds() end, desc = "Close All Folds", },
	     { "zm", function() require("ufo").closeFoldsWith() end, desc = "Close Folds With", },
	     { "zp", function()
	       local winid = require('ufo').peekFoldedLinesUnderCursor()
	       if not winid then
	         vim.lsp.buf.hover()
	       end
	     end, desc = "Peek Fold", },
	   },
    opts = {
      -- fold_virt_text_handler = require('custom.functions.utils').fold_handler,
      provider_selector = function(bufnr, filetype)
        return { "treesitter", "indent" }
      end,
    },
    config = function(_, opts)
      require("ufo").setup(opts)
    end,
  },

  -----------------------------------------------------------------------------
  -- Multi Cursor
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")

      mc.setup()

      -- Add cursors above/below the main cursor.
      vim.keymap.set({ "n", "v" }, "<M-Up>", function()
        mc.addCursor("gk")
      end, { noremap = true, silent = true })
      vim.keymap.set({ "n", "v" }, "<M-Down>", function()
        mc.addCursor("gj")
      end)

      -- Rotate the main cursor.
      vim.keymap.set({ "n", "v" }, "<M-left>", mc.nextCursor)
      vim.keymap.set({ "n", "v" }, "<M-right>", mc.prevCursor)

      -- Add and remove cursors with alt + left click.
      vim.keymap.set("n", "<M-leftmouse>", mc.handleMouse)

      -- Add a cursor and jump to the next word under cursor.
      -- TODO: Find a good replacement
      -- vim.keymap.set({ 'n', 'v' }, '<M-n>', function()
      --   mc.addCursor '*'
      -- end)

      -- Jump to the next word under cursor but do not add a cursor.
      vim.keymap.set({ "n", "v" }, "<c-n>", function()
        mc.skipCursor("*")
      end)

      -- Delete the main cursor.
      -- vim.keymap.set({ 'n', 'v' }, '<leader>z', mc.deleteCursor)

      vim.keymap.set({ "n", "v" }, "<c-q>", function()
        if mc.cursorsEnabled() then
          -- Stop other cursors from moving.
          -- This allows you to reposition the main cursor.
          mc.disableCursors()
        else
          mc.addCursor()
        end
      end)

      -- Handle esc functionality, added nohlsearch to avoid conflicts
      vim.keymap.set("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          vim.cmd("nohlsearch")
        end
      end)

      -- Align cursor columns.
      vim.keymap.set("n", "<leader>a", mc.alignCursors)

      -- Split visual selections by regex.
      vim.keymap.set("v", "S", mc.splitCursors)

      -- Append/insert for each line of visual selections.
      vim.keymap.set("v", "I", mc.insertVisual)
      vim.keymap.set("v", "A", mc.appendVisual)
      -- match new cursors within visual selections by regex.
      vim.keymap.set("v", "M", mc.matchCursors)

      -- Rotate visual selection contents.
      vim.keymap.set("v", "<leader>t", function()
        mc.transposeCursors(1)
      end)
      vim.keymap.set("v", "<leader>T", function()
        mc.transposeCursors(-1)
      end)

      -- Customize how cursors look.
      vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
      vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    end,
  },

  -----------------------------------------------------------------------------
  -- Marks
  {
    "otavioschwanck/arrow.nvim",
    opts = {
      show_icons = true,
      leader_key = "m", -- Recommended to be a single key
      -- buffer_leader_key = 'm', -- Per Buffer Mappings
    },
  },

  {
    "leath-dub/snipe.nvim",
    keys = {
      {
        "gb",
        function()
          require("snipe").open_buffer_menu()
        end,
        desc = "Open Snipe buffer menu",
      },
    },
    opts = {},
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        offsets = {
          {
            filetype = "snacks_layout_box",
            text = "󰙅  File Explorer",
            separator = true,
          },
        },
      },
    },
  },
  -----------------------------------------------------------------------------
  -- Improved jumps
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = {
          char_actions = function(motion)
            return {
              [";"] = "prev",
              [","] = "next",
              [motion:lower()] = "next",
              [motion:upper()] = "prev",
            }
          end,
        },
      },
    },
  },

  { "ethanholz/nvim-lastplace", opts = {} },
  {
    "uga-rosa/ccc.nvim",
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true,
        filetypes = {
          "html",
          "lua",
          "css",
          "scss",
          "sass",
          "less",
          "stylus",
          "javascript",
          "javascriptreact",
          "tmux",
          "json",
          "typescript",
          "typescriptreact",
          "markdown",
        },
        excludes = { "lazy", "mason", "help" },
      },
    },
  },

  -- auto pairs
  {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    opts = {
      enable_check_bracket_line = false,
      ignored_next_char = "[%w%.]",
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        java = false,
      },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup({ opts })
    end,
  },

  -- DEV

  --- Better Visual for help files
  {
    "OXY2DEV/helpview.nvim",
    lazy = false,
    ft = "help",

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },

  ---------------------------------------------------------------------------
  -- Improved yanking
  {
    "gbprod/yanky.nvim",
    recommended = true,
    desc = "Better Yank/Paste",
    event = "VeryLazy",
    opts = {
      highlight = { timer = 150 },
    },
    keys = {
      {
        "<leader>sy",
        function()
          if picker == "snacks" then
            Snacks.picker.yanky()
          else
            vim.cmd([[YankyRingHistory]])
          end
        end,
        mode = { "n", "x" },
        desc = "Open Yank History",
      },
        -- stylua: ignore
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Text After Cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Text After Selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Selection" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put After Applying a Filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put Before Applying a Filter" },
      { "<C-p>", "<Plug>(YankyPreviousEntry)", mode = { "n" }, desc = "Cycle Through Yank History" },
      { "<C-n>", "<Plug>(YankyNextEntry)", mode = { "n" }, desc = "Cycle Back Through Yank History" },
    },
  },

  -----------------------------------------------------------------------------
  -- Adds scrollbar to buffer
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    opts = { show = true, excluded_filetypes = { "NvimTree" } },
  },

  -----------------------------------------------------------------------------
  -- VS Code like winbar
  {
    "utilyre/barbecue.nvim",
    dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<Leader>uB",
        function()
          local off = vim.b["barbecue_entries"] == nil
          require("barbecue.ui").toggle(off and true or nil)
        end,
        desc = "Breadcrumbs toggle",
      },
    },
    opts = {
      enable = true,
      attach_navic = true,
      show_dirname = false,
      show_modified = true,
      -- kinds = kind_icons, -- Uncomment if you have kind_icons defined
      symbols = { separator = "" },
    },
    config = function(_, opts)
      require("barbecue").setup(opts)
    end,
  },

  -----------------------------------------------------------------------------
  -- Improved word navigation
  { "chrisgrieser/nvim-spider", lazy = false },
}
