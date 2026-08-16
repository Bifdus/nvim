return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>ond", "<cmd>Obsidian today<cr>", desc = "obsidian daily" },
      { "<leader>ont", "<cmd>Obsidian today 1<cr>", desc = "obsidian tomorrow" },
      { "<leader>ony", "<cmd>Obsidian today -1<cr>", desc = "obsidian yesterday" },
      { "<leader>onb", "<cmd>Obsidian backlinks<cr>", desc = "obsidian backlinks" },
      { "<leader>onl", "<cmd>Obsidian link<cr>", desc = "obsidian link selection", mode = { "v" } },
      { "<leader>onf", "<cmd>Obsidian follow_link<cr>", desc = "obsidian follow link" },
      { "<leader>onN", "<cmd>Obsidian new<cr>", desc = "obsidian new permanent note" },
      { "<leader>onn", "<cmd>Obsidian new_from_template<cr>", desc = "obsidian new from template" },
      { "<leader>onc", "<cmd>Obsidian toc<cr>", desc = "obsidian view TOC" },
      { "<leader>onT", "<cmd>Obsidian template<cr>", desc = "obsidian insert template" },
      { "<leader>ons", "<cmd>Obsidian search<cr>", desc = "obsidian search" },
      { "<leader>ono", "<cmd>Obsidian quick_switch<cr>", desc = "obsidian quickswitch" },
      { "<leader>onO", "<cmd>Obsidian open<cr>", desc = "obsidian open in app" },
      {
        "<leader>op",
        function()
          -- Get the current date and time in YYYYMMDD_HHMMSS format
          local handle = io.popen("date +%Y%m%d_%H%M%S")
          local timestamp = handle:read("*a")
          handle:close()

          -- Trim any leading/trailing whitespace that io.popen might include
          timestamp = timestamp:gsub("^%s*(.-)%s*$", "%1")

          -- Construct the desired filename
          local filename = "pasted_image-" .. timestamp .. ".png"

          -- Call Obsidian paste_img with the custom filename
          vim.cmd("Obsidian paste_img " .. filename)
        end,
        desc = "Obsidian paste image from clipboard with custom name",
      },
    },
    opts = {
      legacy_commands = false,
      attachments = {
        img_text_func = function(path)
          local original_name = vim.fs.basename(tostring(path))
          local modified_name = string.lower(original_name)

          modified_name = modified_name:gsub("%s+", "_")
          modified_name = modified_name:gsub("[^a-z0-9_-]", "")

          local encoded_original_name = require("obsidian.util").urlencode(original_name)
          return string.format("![%s](%s)", modified_name, encoded_original_name)
        end,
      },

      workspaces = {
        {
          name = "main",
          path = "~/vaults/main",
        },
      },

      notes_subdir = "01 Notes",

      daily_notes = {
        folder = "02 Dailies",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        template = "daily.md",
      },

      templates = {
        folder = "04 Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",

        customizations = {
          fleeting = {
            notes_subdir = "00 Inbox",
          },
          literature = {
            notes_subdir = "01 Notes",
          },
          permanent = {
            notes_subdir = "01 Notes",
          },
          structure = {
            notes_subdir = "01 Notes",
          },
          procedure = {
            notes_subdir = "01 Notes",
          },
          process = {
            notes_subdir = "01 Notes",
          },
          troubleshooting = {
            notes_subdir = "00 Inbox",
          },
          daily = {
            notes_subdir = "02 Dailies",
          },
          meeting = {
            notes_subdir = "03 Meetings",
          },
          reference = {
            notes_subdir = "01 Notes",
          },
          concept = {
            notes_subdir = "01 Notes",
          },
        },
      },

      note_id_func = function(title)
        local suffix = ""
        if title and title ~= "" then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          suffix = tostring(math.random(1000, 9999))
        end
        return os.date("%Y%m%d-%H%M") .. "-" .. suffix
      end,
      checkbox = {
        enabled = true,
        create_new = true,
        order = { " ", "~", "!", ">", "x" },
      },

      ui = {
        enable = false,
        -- checkboxes = {
        --   [" "] = { char = "", hl_group = "ObsidianTodo" },
        --   ["x"] = { char = "", hl_group = "ObsidianDone" },
        --   [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        --   ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        --   ["!"] = { char = "", hl_group = "ObsidianImportant" },
        -- },
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        block_ids = { hl_group = "ObsidianBlockID" },
      },
    },
  },

  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    cmd = "Org",
    dependencies = {
      { "danilshvalov/org-modern.nvim" },
      {
        "hamidi-dev/org-list.nvim",
        dependencies = { "tpope/vim-repeat" },
        opts = {
          mapping = {
            key = "<Leader>osl",
            desc = "org list toggle",
          },
          checkbox_toggle = {
            enabled = true,
            key = "<Leader>osc",
            desc = "org list checkbox toggle",
          },
        },
      },
    },
    keys = {
      { "<Leader>oa", "<cmd>Org agenda<cr>", desc = "org agenda" },
      { "<Leader>oc", "<cmd>Org capture<cr>", desc = "org capture" },
      { "<Leader>ow", "<cmd>Org agenda w<cr>", desc = "org work agenda" },
      { "<Leader>oA", "<cmd>Org agenda A<cr>", desc = "org all agenda" },
      { "<Leader>oTa", "<cmd>EasyAlign|<cr>", desc = "org table align", mode = "v" },
      { "<Leader>oTl", "<cmd>lua align_org_table()<cr>", desc = "org table align (lua)", mode = "v" },
    },
    opts = {
      org_agenda_files = {
        "~/orgfiles/**/*",
      },

      org_default_notes_file = "~/orgfiles/refile.org",
      org_archive_location = "~/orgfiles/archive.org::",

      org_agenda_span = 14,
      org_agenda_start_on_weekday = 1,

      org_agenda_custom_commands = {
        A = {
          description = "📅 Agenda & All Tasks (Global)",
          types = {
            { type = "agenda" },
            { type = "tags_todo" },
          },
        },
        w = {
          description = "💼 Work Focus",
          types = {
            {
              type = "agenda",
              org_agenda_files = { "~/orgfiles/second-brain/work/**/*.org" },
            },
            {
              type = "tags_todo",
              org_agenda_files = { "~/orgfiles/second-brain/work/**/*.org" },
            },
          },
        },
        T = {
          description = "📋 Triage / Planning",
          types = {
            { type = "tags_todo", match = "BACKLOG" },
          },
        },
        i = {
          description = "🚀 In Progress View",
          types = {
            { type = "tags_todo", match = "IN-PROGRESS/IN-REVIEW/TESTING" },
          },
        },
        b = {
          description = "❗ Blocked / Waiting",
          types = {
            { type = "tags_todo", match = "BLOCKED/WAITING/ON-HOLD" },
          },
        },
      },

      org_todo_keywords = {
        "BACKLOG(b)",
        "TODO(t)",
        "NEXT(n)",
        -- "IN-PROGRESS(p)",
        -- "IN-REVIEW(r)",
        -- "TESTING(e)",
        -- "BLOCKED(l)",
        "WAITING(w)",
        -- "ON-HOLD(h)",
        "|",
        "DONE(d)",
        -- "CANCELLED(c)",
        -- "REJECTED(j)",
      },

      org_todo_keyword_faces = {
        BACKLOG = ":foreground #a8a8a8",
        TODO = ":foreground #0088ff :weight bold",
        -- ["IN-PROGRESS"] = ":foreground #ffd700 :weight bold",
        -- ["IN-REVIEW"] = ":foreground #00d7d7 :weight bold",
        NEXT = ":foreground #00d7d7 :weight bold",
        -- TESTING = ":foreground #87ceff :weight bold",
        -- BLOCKED = ":foreground #ff2020 :background #5c0000 :weight bold",
        WAITING = ":foreground #ffd700 :weight bold",
        -- WAITING = ":foreground #ff5faf :weight bold",
        -- ["ON-HOLD"] = ":foreground #d7aaff :weight bold",
        DONE = ":foreground #5fff5f :weight bold",
        -- CANCELLED = ":foreground #585858 :weight bold",
        -- REJECTED = ":foreground #d75f00 :weight bold",
      },

      org_tag_faces = {
        -- IDEA = ":foreground #ffc600 :weight bold",
        -- RAW = ":foreground #af87ff :slant italic",
        PROJECT = ":foreground #ffc600",
        -- APPLICATION = ":foreground #ffc600",
        -- HABIT = ":foreground #ff9d00",
        -- NOTE = ":foreground #9effff :slant italic",
        -- JOURNAL = ":foreground #9effff :slant italic",
        -- LINK = ":foreground #0088ff",
        -- WORK = ":foreground #a5ff90",
        -- NEOVIM = ":foreground #a5ff90 :weight bold",
        -- MEETING = ":foreground #5fffaf",
        -- PHONE = ":foreground #5fffaf",
        BUG = ":foreground #ff628c :weight bold",
        -- FEATURE = ":foreground #ffc600",
        -- REFACTOR = ":foreground #9effff",
        -- DOCS = ":foreground #9effff",
        -- TESTS = ":foreground #9effff",
        -- CRITICAL = ":foreground #ff628c :weight bold",
        HIGH = ":foreground #ff9d00 :weight bold",
        LOW = ":foreground #a8a8a8 :slant italic",
        INCIDENT = ":foreground #ff628c :weight bold",
      },

      org_special_keyword_faces = {
        SCHEDULED = ":foreground #8a8a8a",
        DEADLINE = ":foreground #8a8a8a",
        CLOSED = ":foreground #8a8a8a",
      },

      org_capture_templates = {
        -- i = {
        --   description = "Idea",
        --   subtemplates = {
        --     i = {
        --       description = "Raw Idea",
        --       template = "* %? :IDEA:RAW:",
        --       target = "~/orgfiles/second-brain/work/ideas/inbox.org",
        --       properties = { empty_lines = { before = 1 } },
        --     },
        --     p = {
        --       description = "Project",
        --       template = "* %? :IDEA:PROJECT:",
        --       target = "~/orgfiles/second-brain/work/ideas/project.org",
        --       properties = { empty_lines = { before = 1 } },
        --     },
        --     a = {
        --       description = "Application",
        --       template = "* %? :IDEA:APPLICATION:",
        --       target = "~/orgfiles/second-brain/work/ideas/application.org",
        --       properties = { empty_lines = { before = 1 } },
        --     },
        --     n = {
        --       description = "Neovim",
        --       template = "* %? :IDEA:NEOVIM:",
        --       target = "~/orgfiles/second-brain/work/ideas/neovim.org",
        --       properties = { empty_lines = { before = 1 } },
        --     },
        --     w = {
        --       description = "Work",
        --       template = "* %? :IDEA:WORK:",
        --       target = "~/orgfiles/second-brain/work/ideas/inbox.org",
        --       properties = { empty_lines = { before = 1 } },
        --     },
        --   },
        -- },

        t = {
          description = "Todo",
          template = "* TODO %?\n  %U",
          target = "~/orgfiles/refile.org",
          properties = { empty_lines = { before = 1 } },
        },
      },
    },
    config = function(_, opts)
      local Menu = require("org-modern.menu")

      opts.win_split_mode = 'tabnew'
      opts.ui = opts.ui or {}
      opts.ui.menu = {
        handler = function(data)
          Menu:new({
            window = {
              margin = { 1, 0, 1, 0 },
              padding = { 0, 1, 0, 1 },
              title_pos = "center",
              border = "single",
              zindex = 1000,
            },
            icons = {
              separator = "➜",
            },
          }):open(data)
        end,
      }

      require("orgmode").setup(opts)

      local org = require("orgmode")

      local function find_link()
        local line = vim.api.nvim_get_current_line()
        local col = vim.fn.col(".")
        local search_from = 1

        while true do
          local s, e = line:find("%[%[.-%]%]", search_from)
          if not s then
            return nil
          end

          if col >= s and col <= e then
            return { start_col = s, end_col = e }
          end

          search_from = e + 1
        end
      end

      local FN_MATCHERS = {
        { match = find_link, action = "org_mappings.open_at_point" },
      }

      local NODE_ACTIONS = {
        timestamp = "org_mappings.change_date",
        headline = "org_mappings.todo_next_state",
        listitem = "org_mappings.toggle_checkbox",
        list = "org_mappings.toggle_checkbox",
      }

      local DEFAULT_ACTION = "org_mappings.open_at_point"

      local function get_ts_node_at_cursor()
        if vim.treesitter and vim.treesitter.get_node then
          local row = vim.fn.line(".") - 1
          local col = vim.fn.col(".") - 1
          return vim.treesitter.get_node({ bufnr = 0, pos = { row, col } })
        end

        local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
        if ok and ts_utils.get_node_at_cursor then
          return ts_utils.get_node_at_cursor()
        end
      end

      local function get_action_from_type()
        for _, m in ipairs(FN_MATCHERS) do
          local ok, res = pcall(m.match)
          if ok and res ~= nil then
            return m.action
          end
        end

        local node = get_ts_node_at_cursor()
        if not node then
          return DEFAULT_ACTION
        end

        local start_row = select(1, node:range())
        while node do
          local action = NODE_ACTIONS[node:type()]
          if action then
            return action
          end

          local parent = node:parent()
          if not parent then
            break
          end

          if select(1, parent:range()) ~= start_row then
            break
          end

          node = parent
        end

        return DEFAULT_ACTION
      end

      local function toggle_org_item()
        local action = get_action_from_type()
        if action then
          org.action(action)
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "org",
        callback = function(ev)
          vim.keymap.set("n", "<CR>", toggle_org_item, { buffer = ev.buf, noremap = true, silent = true })
        end,
      })
    end,
  },

  {
    "hamidi-dev/org-super-agenda.nvim",
    dependencies = {
      "nvim-orgmode/orgmode",
    },
    cmd = "OrgSuperAgenda",
    keys = {
      { "<Leader>o.", "<cmd>OrgSuperAgenda<cr>", desc = "org super agenda" },
    },
    config = function()
      local function E(p)
        return vim.fn.expand(p)
      end

      local function glob_list(pat)
        return vim.fn.glob(E(pat), true, true)
      end

      local org_files = {}
      vim.list_extend(org_files, glob_list("~/orgfiles/second-brain/work/**/*.org"))

      local archive = E("~/orgfiles/archive.org")
      org_files = vim.tbl_filter(function(path)
        return path ~= archive
      end, org_files)

      local function has_tag(i, tag)
        return i:has_tag(tag) or i:has_tag(tag:lower()) or i:has_tag(tag:upper())
      end

      local function not_done(i)
        return i.todo_state ~= "DONE" and i.todo_state ~= "CANCELLED" and i.todo_state ~= "REJECTED"
      end

      require("org-super-agenda").setup({
        org_files = org_files,
        org_directories = {},
        exclude_files = {
          archive,
        },
        popup_mode = {
          enabled = false,
          hide_command = nil,
        },
        hide_empty_groups = true,
        show_other_groups = true,
        groups = {
          {
            name = "⏳ Overdue",
            matcher = function(i)
              return not_done(i) and ((i.deadline and i.deadline:is_past()) or (i.scheduled and i.scheduled:is_past()))
            end,
            sort = { by = "date_nearest", order = "asc" },
          },
          {
            name = "💀 Deadlines",
            matcher = function(i)
              return not_done(i) and i.deadline
            end,
            sort = { by = "deadline", order = "asc" },
          },
          {
            name = "📅 Today",
            matcher = function(i)
              return not_done(i) and i.scheduled and i.scheduled:is_today()
            end,
            sort = { by = "priority", order = "desc" },
          },
          {
            name = "📅 Tomorrow",
            matcher = function(i)
              return not_done(i) and i.scheduled and i.scheduled:days_from_today() == 1
            end,
          },
          {
            name = "🚀 In Progress",
            matcher = function(i)
              return not_done(i)
                and (i.todo_state == "IN-PROGRESS" or i.todo_state == "IN-REVIEW" or i.todo_state == "TESTING")
            end,
          },
          {
            name = "🛑 Blocked / Waiting",
            matcher = function(i)
              return not_done(i)
                and (i.todo_state == "BLOCKED" or i.todo_state == "WAITING" or i.todo_state == "ON-HOLD")
            end,
          },
          {
            name = "💼 BHP",
            matcher = function(i)
              return has_tag(i, "BHP")
            end,
          },
          {
            name = "💼 HAFAS",
            matcher = function(i)
              return has_tag(i, "HAFAS")
            end,
          },
        },
      })
    end,
  },

  -- {
  --   "lukas-reineke/headlines.nvim",
  --   ft = { "markdown" },
  --   enabled = false,
  --   config = function()
  --     -- Colors for orgmode headlines
  --     vim.cmd([[highlight Headline1 guibg=#21262d]])
  --     -- vim.cmd [[highlight Headline2 guibg=#21262d]]
  --
  --     local bullet_highlighs = {
  --       "@markup.heading.1.markdown",
  --       "@markup.heading.2.markdown",
  --       "@markup.heading.3.markdown",
  --       "@markup.heading.4.markdown",
  --       "@markup.heading.5.markdown",
  --       "@markup.heading.6.markdown",
  --     }
  --     require("headlines").setup({
  --       org = {
  --         headline_highlights = { "Headline1" },
  --         bullets = { "◉", "○", "✸", "✿" },
  --         bullet_highlighs = bullet_highlighs,
  --       },
  --     })
  --   end,
  -- },

  -----------------------------------------------------------------------------
  -- Preview Markdown
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    -- cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_browser = "Firefox"
    end,
  },

  -----------------------------------------------------------------------------
  -- Render Markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    enabled = true,
    config = function()
      -- Treat Telekasten buffers as markdown for treesitter-based renderers.
      vim.treesitter.language.register("markdown", "telekasten")
      require("render-markdown").setup({
        auto_open = true,
        auto_close = true,

        win_options = {
          -- Window options to use that change between rendered and raw view.

          -- @see :h 'conceallevel'
          conceallevel = {
            -- Used when not being rendered, get user setting.
            default = vim.o.conceallevel,
            -- Used when being rendered, concealed text is completely hidden.
            rendered = 2,
          },
          -- @see :h 'concealcursor'
          concealcursor = {
            -- Used when not being rendered, get user setting.
            default = vim.o.concealcursor,
            -- Used when being rendered, show concealed text in all modes.
            rendered = "",
          },
        },
        indent = {
          enabled = true,
          per_level = 4,
          skip_heading = true,
        },
        -- Add more options based on the plugin's documentation
        heading = {
          sign = false,
          enabled = true,
          icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
          foregrounds = {
            "RainbowDelimiterBlue",
            "RainbowDelimiterViolet",
            "RainbowDelimiterGreen",
            "RainbowDelimiterCyan",
          },
        },
        code = {
          enabled = true,
          style = "full",
          highlight = "DraculaBgLighter",
          width = "block",
        },
        -- },
      })

      -- Render markdown highlights
      local function set_render_markdown_highlights()
        vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { link = "DraculaPurpleBold" })
        vim.api.nvim_set_hl(0, "RenderMarkdownH1", { link = "DraculaPurpleBold" })

        vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { link = "DraculaOrangeBold" })
        vim.api.nvim_set_hl(0, "RenderMarkdownH2", { link = "DraculaOrangeBold" })

        vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { link = "DraculaGreenBold" })
        vim.api.nvim_set_hl(0, "RenderMarkdownH3", { link = "DraculaGreenBold" })

        vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { fg = "#80FFEA", bold = true })
        vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = "#80FFEA", bold = true })

        vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { fg = "#FF80BF", bold = true })
        vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = "#FF80BF", bold = true })

        vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { link = "DraculaPurpleBold" })
        vim.api.nvim_set_hl(0, "RenderMarkdownH6", { link = "DraculaPurpleBold" })

        vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = "#FF80BF", bold = true })
        vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = "#FF80BF", bold = true })
      end

      set_render_markdown_highlights()

      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_render_markdown_highlights })
    end,
    -- Optional: Lazy-load based on file type
    ft = { "markdown", "md", "telekasten" },
    keys = {
      { "<leader>rm", "<cmd>RenderMarkdown<CR>", desc = "Render Markdown" },
    },
  },
  {
    "jakewvincent/mkdnflow.nvim",
    enabled = false,
    config = function()
      require("mkdnflow").setup({
        -- mappings = {
        --   MkdnNextLink = { false },
        -- },
      })
    end,
  },

  -- {
  --   "bngarren/checkmate.nvim",
  --   ft = "markdown",
  --   opts = {
  --     -- files = { "*.md" }, -- any .md file (instead of defaults)
  --   },
  -- },
  --
  {
    "jbyuki/venn.nvim",
  },
}
