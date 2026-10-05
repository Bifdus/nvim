return {

  {
    "nvim-orgmode/orgmode",
    -- event = "VeryLazy",
    -- ft = { "org" },
    -- cmd = "Org",
    keys = {
      { "<Leader>oa", "<cmd>Org agenda<cr>", desc = "org agenda" },
      { "<Leader>oc", "<cmd>Org capture<cr>", desc = "org capture" },
      {
        "<Leader>or",
        function()
          require("util.org_refile").pick_destination()
        end,
        ft = "org",
        desc = "Org: pick refile destination",
      },
    },
    opts = {
      org_agenda_files = {
        "~/orgfiles/**/*",
      },

      org_default_notes_file = "~/orgfiles/refile.org",
      org_archive_location = "~/orgfiles/archive.org::",
      org_startup_indented = true,
      org_startup_folded = "content",

      org_todo_keywords = {
        "TODO(t)",
        "NEXT(n)",
        "WAITING(w)",
        "BACKLOG(l)",
        "|",
        "DONE(d)",
      },

      org_todo_keyword_faces = {
        TODO = ":foreground #8be9fd :weight bold", -- Dracula cyan
        NEXT = ":foreground #bd93f9 :weight bold", -- Dracula purple
        WAITING = ":foreground #ffb86c :weight bold", -- Dracula orange
        DONE = ":foreground #50fa7b :weight bold", -- Dracula green
        BACKLOG = ":foreground #898989 :weight bold", -- Dracula green
      },

      org_capture_templates = {
        t = {
          description = "Task",
          template = "* TODO %?\n  %U",
          target = "~/orgfiles/refile.org",
          properties = { empty_lines = { before = 1 } },
        },
      },

      mappings = {
        agenda = {
          -- <Tab> is indistinguishable from <C-i> in most terminals.
          org_agenda_goto = false,
          org_agenda_add_note = { "<prefix>na", desc = "Append note below agenda headline" },
        },
        note = {
          -- Closing a note with the global window mapping runs after its buffer
          -- was wiped, making Orgmode read the source task as note content.
          -- Finalize or discard while the temporary note buffer still exists.
          org_note_finalize = { "<C-c>", "<leader>wd", desc = "Save note below headline" },
          org_note_kill = { "<prefix>k", "<leader>wD", desc = "Discard note" },
        },
        capture = {
          -- Replaced by the Snacks destination picker below.
          org_capture_refile = false,
        },
        org = {
          org_add_note = { "<prefix>na", desc = "Append note below headline" },
          org_cycle = false,
          -- Replaced by the Snacks destination picker below.
          org_refile = false,
        },
      },
    },
    config = function(_, opts)
      opts.win_split_mode = "tabnew"
      require("orgmode").setup(opts)

      local org = require("orgmode")
      local node_actions = {
        timestamp = "org_mappings.change_date",
        headline = "org_mappings.todo_next_state",
        listitem = "org_mappings.toggle_checkbox",
        list = "org_mappings.toggle_checkbox",
      }

      local function org_return()
        local node = vim.treesitter.get_node()
        local row = node and select(1, node:range())
        while node do
          local action = node_actions[node:type()]
          if action then
            return org.action(action)
          end

          node = node:parent()
          if not node or select(1, node:range()) ~= row then
            break
          end
        end

        org.action("org_mappings.open_at_point")
      end

      local function set_org_keymaps(buf)
        vim.keymap.set("n", "<CR>", org_return, {
          buffer = buf,
          desc = "Org: context action",
          silent = true,
        })
        vim.keymap.set("n", "<leader>or", require("util.org_refile").pick_destination, {
          buffer = buf,
          desc = "Org: pick refile destination",
        })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "org",
        callback = function(ev)
          set_org_keymaps(ev.buf)
        end,
      })

      if vim.bo.filetype == "org" then
        set_org_keymaps(0)
      end
    end,
  },
  {
    "hamidi-dev/org-super-agenda.nvim",
    dependencies = {
      "nvim-orgmode/orgmode",
      -- { "lukas-reineke/headlines.nvim", config = true },
    },
    cmd = "OrgSuperAgenda",
    keys = {
      { "<Leader>o.", "<cmd>OrgSuperAgenda!<cr>", desc = "org super agenda" },
    },
    config = function()
      local refile = vim.fn.expand("~/orgfiles/refile.org")
      local archive = vim.fn.expand("~/orgfiles/archive.org")

      local function has_tag(item, tag)
        return item:has_tag(tag) or item:has_tag(tag:lower()) or item:has_tag(tag:upper())
      end

      local function not_done(item)
        return item.todo_state ~= "DONE"
      end

      require("org-super-agenda").setup({
        org_files = { refile },
        exclude_files = { archive },

        todo_states = {
          {
            name = "TODO",
            keymap = "ot",
            color = "#8be9fd",
            strike_through = false,
            fields = { "todo", "headline", "priority", "date", "tags" },
          },
          {
            name = "NEXT",
            keymap = "op",
            color = "#bd93f9",
            strike_through = false,
            fields = { "todo", "headline", "priority", "date", "tags" },
          },
          {
            name = "WAITING",
            keymap = "ow",
            color = "#ffb86c",
            strike_through = false,
            fields = { "todo", "headline", "priority", "date", "tags" },
          },
          {
            name = "DONE",
            keymap = "od",
            color = "#50fa7b",
            strike_through = true,
            fields = { "todo", "headline", "priority", "date", "tags" },
          },
          {
            name = "BACKLOG",
            keymap = "ol",
            color = "#898989",
            strike_through = false,
            fields = { "todo", "headline", "priority", "date", "tags" },
          },
        },

        keymaps = {
          filter_reset = "oa",
          toggle_other = "oo",
          filter = "of",
          filter_fuzzy = "oz",
          filter_query = "oq",
          undo = "u",
          reschedule = "cs",
          set_deadline = "cd",
          cycle_todo = "t",
          set_state = "s",
          reload = "r",
          refile = "R",
          hide_item = "x",
          preview = "K",
          clock_in = "I",
          clock_out = "O",
          clock_cancel = "X",
          clock_goto = "gI",
          reset_hidden = "gX",
          fold_all = "zM",
          unfold_all = "zR",
          toggle_duplicates = "D",
          cycle_view = "ov",
          bulk_mark = "m",
          bulk_unmark_all = "M",
          bulk_reselect = "gv",
          bulk_action = "B",
          open_view = "V",
        },

        window = {
          width = 0.8,
          height = 0.7,
          border = "rounded",
          title = "Org Super Agenda",
          title_pos = "center",
          margin_left = 0,
          margin_right = 0,
          fullscreen_border = "none",
        },

        groups = {
          {
            name = "💥 Overdue",
            matcher = function(i)
              return not_done(i) and ((i.deadline and i.deadline:is_past()) or (i.scheduled and i.scheduled:is_past()))
            end,
            sort = { by = "date_nearest", order = "asc" },
          },
          {
            name = "📅 Today",
            matcher = function(i)
              return not_done(i) and ((i.scheduled and i.scheduled:is_today()) or (i.deadline and i.deadline:is_today()))
            end,
            sort = { by = "scheduled_time", order = "asc" },
          },
          {
            name = "⏰ Deadlines",
            matcher = function(i)
              return not_done(i) and i.deadline
            end,
            sort = { by = "deadline", order = "asc" },
          },
          {
            name = "⛔ Waiting",
            matcher = function(i)
              return i.todo_state == "WAITING"
            end,
          },
          {
            name = "➡️ Next",
            matcher = function(i)
              return i.todo_state == "NEXT"
            end,
          },
          {
            name = "❇️ Important",
            matcher = function(i)
              return not_done(i) and i.priority == "A"
            end,
            sort = { by = "date_nearest", order = "asc" },
          },
          {
            name = "📦 Backlog",
            matcher = function(i)
              return i.todo_state == "BACKLOG"
            end,
          },
          {
            name = "🗓️ Upcoming",
            matcher = function(i)
              local days = require("org-super-agenda.config").get().upcoming_days or 10
              local d1 = i.deadline and i.deadline:days_from_today()
              local d2 = i.scheduled and i.scheduled:days_from_today()
              return not_done(i) and ((d1 and d1 >= 0 and d1 <= days) or (d2 and d2 >= 0 and d2 <= days))
            end,
            sort = { by = "date_nearest", order = "asc" },
          },
        },

        upcoming_days = 10,
        hide_empty_groups = true,
        keep_order = false,
        allow_duplicates = false,
        group_format = "* %s",
        other_group_name = "Other",
        show_other_group = true,
        show_tags = true,
        show_filename = true,
        bulk_action_prompt = "keys",
        heading_max_length = 70,
        persist_hidden = false,
        view_mode = "classic",

        classic = {
          heading_order = { "filename", "todo", "priority", "headline" },
          short_date_labels = false,
          inline_dates = true,
        },

        compact = {
          filename_min_width = 10,
          label_min_width = 12,
        },

        tree = {
          show_ghost_parents = true,
        },

        group_sort = { by = "date_nearest", order = "asc" },

        debug = false,

        custom_views = {
          work_week = {
            name = "Work This Week",
            keymap = "<leader>ow",
            filter = "tag:work sched>=0 sched<7 -is:done",
          },
          bhp = {
            name = "BHP",
            keymap = "<leader>ob",
            filter = "tag:BHP -is:done",
          },
          hafas = {
            name = "HAFAS",
            keymap = "<leader>oh",
            filter = "tag:HAFAS -is:done",
          },
        },
      })
    end,
  },
}
