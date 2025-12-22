return {
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    tag = "0.7.0",
    ft = "org",
    cmd = "Org",
    init = function()
      local wk = require("which-key")
      local org_icon = { icon = "", color = "green" }
      wk.add({
        { "<Leader>o", group = "[O]rg-mode", icon = org_icon },
        { "<Leader>ob", group = "org tangle", icon = org_icon },
        { "<Leader>od", group = "org dates", icon = org_icon },
        { "<Leader>oi", group = "org insert", icon = org_icon },
        { "<Leader>ol", group = "org links", icon = org_icon },
        { "<Leader>on", group = "org notes", icon = org_icon },
        { "<Leader>os", group = "org toggle", icon = org_icon },
        { "<Leader>ox", group = "org clock", icon = org_icon },
        { "<Leader>n", group = "org roam", icon = org_icon },
        { "<Leader>na", group = "org roam alias", icon = org_icon },
        { "<Leader>no", group = "org roam origin", icon = org_icon },
        { "<Leader>nd", group = "org roam dailies", icon = org_icon },
      })
    end,
    keys = {
      { "<Leader>oa", "<cmd>Org agenda<cr>", desc = "org agenda" },
      { "<Leader>oc", "<cmd>Org capture<cr>", desc = "org capture" },
      { "<Leader>ow", "<cmd>Org agenda w<cr>", desc = "org work agenda" },
      { "<Leader>op", "<cmd>Org agenda p<cr>", desc = "org personal agenda" },
      { "<Leader>oTa", "<cmd>EasyAlign|<cr>", desc = "org table align", mode = "v" },
      { "<Leader>oTl", "<cmd>lua align_org_table()<cr>", desc = "org table align (lua)", mode = "v" },
    },

    dependencies = {
      {
        "akinsho/org-bullets.nvim",
        opts = {
          concealcursor = true,
          symbols = {
            checkboxes = {
              half = { "", "@org.checkbox.halfchecked" },
              done = { "✓", "@org.checkbox.checked" },
              todo = { " ", "@org.checkbox" },
            },
          },
        },
      },
      {
        "danilshvalov/org-modern.nvim",
      },
      {
        "hamidi-dev/org-list.nvim",
        dependencies = {
          "tpope/vim-repeat",
        },
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
    opts = {
      org_agenda_files = {
        "~/orgfiles/second-brain/work/**/*.org", -- work todo
        "~/orgfiles/second-brain/personal/**/*.org", -- personal todo
      },
      org_default_notes_file = "~/orgfiles/refile.org",

      org_archive_location = "~/orgfiles/archive.org::",

      org_agenda_span = 14,
      --
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
        p = {
          description = "🏠 Personal Focus",
          types = {
            {
              type = "agenda",
              org_agenda_files = { "~/orgfiles/second-brain/personal/**/*.org" },
            },
            {
              type = "tags_todo",
              org_agenda_files = { "~/orgfiles/second-brain/personal/**/*.org" },
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
            { type = "tags_todo", match = "BLOCKED/WAITING" },
          },
        },
      },
      org_todo_keywords = {
        -- 1. PLANNING & TRIAGE STAGES
        "BACKLOG(B)",
        "TODO(t)",

        -- 2. ACTIVE DEVELOPMENT STAGES
        "IN-PROGRESS(p)", -- "p" for "progress"
        "IN-REVIEW(r)", -- "r" for "review"
        "TESTING(e)", -- "e" from "t**e**sting"

        -- 3. WAITING / PAUSED STAGES
        "BLOCKED(l)", -- "l" from "b**l**ocked"
        "WAITING(w)",
        "ON-HOLD(h)",

        -- SEPARATOR
        "|",

        -- 5. TERMINAL STAGES
        "DONE(d)",
        "CANCELLED(c)",
        "REJECTED(j)",
      },
      org_todo_keyword_faces = {
        -- Planning Faces
        BACKLOG = ":foreground #a8a8a8",
        TODO = ":foreground #0088ff :weight bold",
        -- Active Dev Faces
        ["IN-PROGRESS"] = ":foreground #ffd700 :weight bold",
        ["IN-REVIEW"] = ":foreground #00d7d7 :weight bold",
        TESTING = ":foreground #87ceff :weight bold",
        -- Waiting/Paused Faces
        BLOCKED = ":foreground #ff2020 :background #5c0000 :weight bold",
        WAITING = ":foreground #ff5faf :weight bold",
        ["ON-HOLD"] = ":foreground #d7aaff :weight bold",
        -- Terminal Faces
        DONE = ":foreground #5fff5f :weight bold",
        CANCELLED = ":foreground #585858 :weight bold",
        REJECTED = ":foreground #d75f00 :weight bold",
      },
      org_tag_faces = {
        -------------------------------------------------------------------------
        -- === BY TYPE (What kind of thing is this?) ===
        -------------------------------------------------------------------------
        -- Use the vibrant Cobalt2 yellow for creative/new items
        IDEA = ":foreground #ffc600 :weight bold",
        RAW = ":foreground #af87ff :slant italic",
        PROJECT = ":foreground #ffc600",
        APPLICATION = ":foreground #ffc600",

        -- Use the action-oriented Cobalt2 orange for recurring tasks
        HABIT = ":foreground #ff9d00",

        -- Use a calm, italic light blue for reflective entries
        NOTE = ":foreground #9effff :slant italic",
        JOURNAL = ":foreground #9effff :slant italic",

        -- Use a simple, non-intrusive blue for utility tags
        LINK = ":foreground #0088ff",

        -------------------------------------------------------------------------
        -- === BY CONTEXT (Where does this belong?) ===
        -------------------------------------------------------------------------
        -- Use the pleasant Cobalt2 green for your main work context
        WORK = ":foreground #a5ff90",

        -- A distinct, friendly blue for personal context
        PERSONAL = ":foreground #0088ff",

        -- A bold, thematic green for Neovim-specific items
        NEOVIM = ":foreground #a5ff90 :weight bold",

        -------------------------------------------------------------------------
        -- === BY EVENT (What kind of appointment is this?) ===
        -------------------------------------------------------------------------
        -- A consistent green for meetings and calls
        MEETING = ":foreground #5fffaf",
        PHONE = ":foreground #5fffaf",

        -------------------------------------------------------------------------
        -- === MANUAL DEV TAGS (For you to type manually) ===
        -------------------------------------------------------------------------
        -- High-alert Cobalt2 pink for critical issues
        BUG = ":foreground #ff628c :weight bold",

        -- Cobalt2 yellow for new development work
        FEATURE = ":foreground #ffc600",

        -- Cobalt2 light blue for code maintenance
        REFACTOR = ":foreground #9effff",
        DOCS = ":foreground #9effff",
        TESTS = ":foreground #9effff",

        -------------------------------------------------------------------------
        -- === MANUAL PRIORITY TAGS (For you to type manually) ===
        -------------------------------------------------------------------------
        CRITICAL = ":foreground #ff628c :weight bold",
        HIGH = ":foreground #ff9d00 :weight bold",
        LOW = ":foreground #a8a8a8 :slant italic",
      },
      org_special_keyword_faces = {
        SCHEDULED = ":foreground #8a8a8a",
        DEADLINE = ":foreground #8a8a8a",
        CLOSED = ":foreground #8a8a8a",
      },
      org_capture_templates = {
        i = {
          description = "Idea",
          subtemplates = {
            i = {
              description = "Raw Idea",
              template = "* %? :IDEA:RAW:",
              target = "~orgfiles/second-brain/work/ideas/inbox.org",
              properties = { empty_lines = { before = 1 } },
            },
            p = {
              description = "Project",
              template = "* %? :IDEA:PROJECT:",
              target = "~orgfiles/second-brain/work/ideas/project.org",
              properties = { empty_lines = { before = 1 } },
            },
            a = {
              description = "Application",
              template = "* %? :IDEA:APPLICATION:",
              target = "~/orgfiles/second-brain/work/ideas/application.org",
              properties = { empty_lines = { before = 1 } },
            },
            n = {
              description = "Neovim",
              template = "* %? :IDEA:NEOVIM:",
              target = "~orgfiles/second-brain/work/ideas/neovim.org",
              properties = { empty_lines = { before = 1 } },
            },
            w = {
              description = "Work",
              template = "* %? :IDEA:WORK:",
              target = "~/orgfiles/second-brain/work/ideas/inbox.org",
              properties = { empty_lines = { before = 1 } },
            },
          },
        },

        t = {
          description = "Task",
          subtemplates = {
            p = {
              description = "Personal",
              template = "* TODO %? :TASK:PERSONAL\n  SCHEDULED: %U DEADLINE: %t",
              target = "~/orgfiles/second-brain/personal/agenda/todos.org",
              properties = { empty_lines = { before = 1 } },
            },
            n = {
              description = "Neovim",
              template = "* TODO %? :NEOVIM:TASK:\n  SCHEDULED: %U DEADLINE: %t",
              target = "~/orgfiles/second-brain/personal/agenda/todos.org",
              properties = { empty_lines = { before = 1 } },
            },
            w = {
              description = "Work",
              template = "* TODO %? :TASK:WORK:\n  SCHEDULED: %U DEADLINE: %t",
              target = "~/orgfiles/second-brain/work/agenda/todos.org",
              properties = { empty_lines = { before = 1 } },
            },
          },
        },

        n = {
          description = "Note",
          subtemplates = {
            p = {
              description = "Personal",
              template = "* %^{Title} :NOTE:\n  %U\n\n%?",
              target = "~/orgfiles/second-brain/personal/notes/inbox.org",
              properties = { empty_lines = { before = 1 } },
            },
            w = {
              description = "Work",
              template = "* %^{Title} :NOTE:WORK:\n  %U\n\n%?",
              target = "~/orgfiles/second-brain/work/notes/inbox.org",
              properties = { empty_lines = { before = 1 } },
            },
          },
        },

        j = {
          description = "Journal",
          subtemplates = {
            p = {
              description = "Personal",
              target = "~/orgfiles/second-brain/personal/journal/inbox.org",
              template = "**** [%<%I:%M %p>] %?",
              datetree = { tree_type = "day", reversed = true },
              properties = { empty_lines = { before = 1 } },
            },
            w = {
              description = "Work",
              target = "~/orgfiles/second-brain/personal/journal/inbox.org",
              template = "**** [%<%I:%M %p>] %? :WORK:",
              datetree = { tree_type = "day", reversed = true },
              properties = { empty_lines = { before = 1 } },
            },
          },
        },

        m = {
          description = "Meeting",
          subtemplates = {
            p = {
              description = "Personal",
              template = "* MEETING with %? :MEETING:\n  SCHEDULED: %t",
              target = "~/orgfiles/second-brain/personal/agenda/calls.org",
              properties = { empty_lines = { before = 1 } },
            },
            w = {
              description = "Work",
              template = "* MEETING with %? :MEETING:WORK:\n  SCHEDULED: %t",
              target = "~/orgfiles/second-brain/work/agenda/calls.org",
              properties = { empty_lines = { before = 1 } },
            },
          },
        },

        p = {
          description = "Phone Call",
          subtemplates = {
            p = {
              description = "Personal",
              template = "* CALL with %? :PHONE:\n  SCHEDULED: %t",
              target = "~/orgfiles/second-brain/personal/agenda/calls.org",
              properties = { empty_lines = { before = 1 } },
            },
            w = {
              description = "Work",
              template = "* CALL with %? :PHONE:WORK:\n  SCHEDULED: %t",
              target = "~/orgfiles/second-brain/work/agenda/calls.org",
              properties = { empty_lines = { before = 1 } },
            },
          },
        },

        h = {
          description = "Habit",
          subtemplates = {
            p = {
              description = "Personal",
              template = "* NEXT %? :HABIT:\n  SCHEDULED: %t\n  :PROPERTIES:\n  :STYLE: habit\n  :REPEAT_TO_STATE: NEXT\n  :END:",
              target = "~/orgfiles/second-brain/personal/agenda/habits.org",
              properties = { empty_lines = { before = 1 } },
            },
            w = {
              description = "Work",
              template = "* NEXT %? :HABIT:WORK:\n  SCHEDULED: %t\n  :PROPERTIES:\n  :STYLE: habit\n  :REPEAT_TO_STATE: NEXT\n  :END:",
              target = "~/orgfiles/second-brain/work/agenda/habits.org",
              properties = { empty_lines = { before = 1 } },
            },
          },
        },

        l = {
          description = "Link",
          subtemplates = {
            r = {
              description = "Useful resource links",
              template = "  - [[%^{Link||}][%^{Description}]] :LINK:",
              headline = "Useful resource links",
              target = "~/orgfiles/second-brain/personal/vocabulary/links.org",
            },
          },
        },
      },
    },
    config = function(_, opts)
      local Menu = require("org-modern.menu")

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
        local col = vim.fn.col(".") -- 1-indexed
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

        -- Fallback for older setups
        local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
        if ok and ts_utils.get_node_at_cursor then
          return ts_utils.get_node_at_cursor()
        end
      end

      local function get_action_from_type()
        -- 1) Run function matchers ONCE
        for _, m in ipairs(FN_MATCHERS) do
          local ok, res = pcall(m.match)
          if ok and res ~= nil then
            return m.action
          end
        end

        -- 2) Treesitter walk up the parent chain (same row only)
        local node = get_ts_node_at_cursor()
        if not node then
          return DEFAULT_ACTION
        end

        local start_row = select(1, node:range()) -- range() returns 4 values
        while node do
          local action = NODE_ACTIONS[node:type()]
          if action then
            return action
          end

          local parent = node:parent()
          if not parent then
            break
          end

          -- Stop if we moved off the original line
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
    "chipsenkbeil/org-roam.nvim",
    tag = "0.2.0",
    dependencies = {
      {
        "nvim-orgmode/orgmode",
      },
    },
    keys = {
      { "<Leader>nc", desc = "org-roam: capture" },
      { "<Leader>nf", desc = "org-roam: find node" },
      { "<Leader>ni", desc = "org-roam: insert node (capture if new)" },
      { "<Leader>nm", desc = "org-roam: insert node (no capture buffer)" },
      { "<Leader>nl", desc = "org-roam: toggle roam buffer (node view)" },
      { "<Leader>nb", desc = "org-roam: toggle fixed roam buffer (pick node)" },
      { "<Leader>nq", desc = "org-roam: backlinks quickfix" },
      { "<Leader>n.", desc = "org-roam: complete node at point" },

      -- Navigation (origin chain)
      { "<Leader>nn", desc = "org-roam: next node (via origin)" },
      { "<Leader>np", desc = "org-roam: prev node (via origin)" },

      -- Alias
      { "<Leader>naa", desc = "org-roam: add alias" },
      { "<Leader>nar", desc = "org-roam: remove alias" },

      -- Origin
      { "<Leader>noa", desc = "org-roam: add origin" },
      { "<Leader>nor", desc = "org-roam: remove origin" },

      -- Dailies (all global)
      { "<Leader>ndN", desc = "org-roam dailies: capture today" },
      { "<Leader>ndY", desc = "org-roam dailies: capture yesterday" },
      { "<Leader>ndT", desc = "org-roam dailies: capture tomorrow" },
      { "<Leader>ndD", desc = "org-roam dailies: capture specific date" },

      { "<Leader>ndn", desc = "org-roam dailies: goto today" },
      { "<Leader>ndy", desc = "org-roam dailies: goto yesterday" },
      { "<Leader>ndt", desc = "org-roam dailies: goto tomorrow" },
      { "<Leader>ndd", desc = "org-roam dailies: goto specific date" },
      { "<Leader>ndf", desc = "org-roam dailies: goto next date" },
      { "<Leader>ndb", desc = "org-roam dailies: goto prev date" },
      { "<Leader>nd.", desc = "org-roam dailies: open dailies directory" },
    },
    opts = {
      directory = "~/orgfiles/second-brain/personal/notes",
      bindings = {
        prefix = "<Leader>n",
      },
    },
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
      vim.list_extend(org_files, glob_list("~/orgfiles/second-brain/personal/**/*.org"))

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
          E("~orgfiles/archive.org"),
        },
        popup_mode = {
          enabled = false,
          hide_command = nil, -- e.g., "tmux detach-client"
        },
        -- todo_states = {
        --   {
        --     name = "BACKLOG",
        --     keymap = "ob",
        --     color = "#a8a8a8",
        --     strike_through = false,
        --     fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        --   },
        --   {
        --     name = "TODO",
        --     keymap = "ot",
        --     color = "#0088ff",
        --     strike_through = false,
        --     fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        --   },
        --   {
        --     name = "IN-PROGRESS",
        --     keymap = "op",
        --     color = "#ffd700",
        --     strike_through = false,
        --     fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        --   },
        --   {
        --     name = "IN-REVIEW",
        --     keymap = "or",
        --     color = "#00d7d7",
        --     strike_through = false,
        --     fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        --   },
        --   {
        --     name = "TESTING",
        --     keymap = "oe",
        --     color = "#87ceff",
        --     strike_through = false,
        --     fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        --   },
        --   {
        --     name = "BLOCKED",
        --     keymap = "ol",
        --     color = "#ff2020",
        --     strike_through = false,
        --     fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        --   },
        --   {
        --     name = "WAITING",
        --     keymap = "ow",
        --     color = "#ff5faf",
        --     strike_through = false,
        --     fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        --   },
        --   {
        --     name = "ON-HOLD",
        --     keymap = "oh",
        --     color = "#d7aaff",
        --     strike_through = false,
        --     fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        --   },
        --   {
        --     name = "DONE",
        --     keymap = "od",
        --     color = "#5fff5f",
        --     strike_through = true,
        --     fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        --   },
        --   {
        --     name = "CANCELLED",
        --     keymap = "oc",
        --     color = "#585858",
        --     strike_through = true,
        --     fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        --   },
        --   {
        --     name = "REJECTED",
        --     keymap = "oj",
        --     color = "#d75f00",
        --     strike_through = true,
        --     fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        --   },
        -- },
        hide_empty_groups = false,
        show_other_groups = true,
        groups = {
          {
            name = "📅 Today",
            matcher = function(i)
              return not_done(i) and i.scheduled and i.scheduled:is_today()
            end,
            sort = { by = "priority", order = "desc" },
          },
          {
            name = "🗓️ Tomorrow",
            matcher = function(i)
              return not_done(i) and i.scheduled and i.scheduled:days_from_today() == 1
            end,
          },
          {
            name = "☠️ Deadlines",
            matcher = function(i)
              return not_done(i) and i.deadline and not has_tag(i, "PERSONAL")
            end,
            sort = { by = "deadline", order = "asc" },
          },
          {
            name = "⏳ Overdue",
            matcher = function(i)
              return not_done(i) and ((i.deadline and i.deadline:is_past()) or (i.scheduled and i.scheduled:is_past()))
            end,
            sort = { by = "date_nearest", order = "asc" },
          },
          {
            name = "🏠 Personal",
            matcher = function(i)
              return has_tag(i, "PERSONAL")
            end,
          },
          {
            name = "💼 Work",
            matcher = function(i)
              return has_tag(i, "WORK")
            end,
          },
        },
      })
    end,
  },
}
