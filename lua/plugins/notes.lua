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


  -----------------------------------------------------------------------------
  -- Preview Markdown
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    -- init = function()
    --   vim.g.mkdp_browser = "wslview"
    -- end,
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
