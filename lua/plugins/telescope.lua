return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',

        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-file-browser.nvim' },
      { 'nvim-telescope/telescope-project.nvim' },
      { 'polirritmico/telescope-lazy-plugins.nvim' },
      { 'debugloop/telescope-undo.nvim' },
      {'nvim-telescope/telescope-symbols.nvim'},
      {
        'rcarriga/nvim-notify',
        config = function()
          vim.notify = require('notify')
        end,
      },

      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          lazy_plugins = {
            lazy_config = vim.fn.stdpath('config') .. '/init.lua'
          }
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'file_browser')
      pcall(require('telescope').load_extension, 'project')
      pcall(require("telescope").load_extension, "lazy_plugins")
      pcall(require('telescope').load_extension, 'undo')
      pcall(require('telescope').load_extension, 'notify')
      pcall(require('telescope').load_extension, 'telescope-symbols')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      local extensions = require('telescope').extensions
      local function buffer_fuzzy_find()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end

      local function grep_open_files()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end

      local function smart_find_files()
        local ok = pcall(vim.fn.system, 'git rev-parse --is-inside-work-tree')
        if ok and vim.v.shell_error == 0 then
          builtin.git_files()
        else
          builtin.find_files()
        end
      end

      local function git_log_line()
        if vim.fn.mode():match('[vV]') then
          builtin.git_bcommits_range()
        else
          local line = vim.fn.line('.')
          builtin.git_bcommits_range({ from = line, to = line })
        end
      end

      vim.keymap.set('n', '<leader><space>', smart_find_files, { desc = 'Smart Find Files' })
      vim.keymap.set('n', '<leader>,', builtin.buffers, { desc = 'Buffers' })
      vim.keymap.set('n', '<leader>:', builtin.command_history, { desc = 'Command History' })
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sm', builtin.man_pages, { desc = '[S] Man Files' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
      vim.keymap.set('n', '<leader>fc', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'Find Config File' })
      vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = 'Find Git Files' })
      vim.keymap.set('n', '<leader>fp', extensions.project.project, { desc = 'Projects' })
      vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent' })
      vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = 'Git Branches' })
      vim.keymap.set('n', '<leader>gl', builtin.git_commits, { desc = 'Git Log' })
      vim.keymap.set({ 'n', 'x' }, '<leader>gL', git_log_line, { desc = 'Git Log Line' })
      vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Git Status' })
      vim.keymap.set('n', '<leader>gS', builtin.git_stash, { desc = 'Git Stash' })
      vim.keymap.set('n', '<leader>gf', builtin.git_bcommits, { desc = 'Git Log File' })
      vim.keymap.set('n', '<leader>\\', extensions.file_browser.file_browser, { desc = 'Explorer' })
      vim.keymap.set('n', '<leader>e', extensions.file_browser.file_browser, { desc = 'Explorer' })
      vim.keymap.set('n', '<leader>E', function()
        extensions.file_browser.file_browser { cwd = Util.root.cwd() }
      end, { desc = 'Explorer (Root)' })
      vim.keymap.set('n', '<leader>sb', buffer_fuzzy_find, { desc = 'Buffer Lines' })
      vim.keymap.set('n', '<leader>sB', grep_open_files, { desc = 'Grep Open Buffers' })
      vim.keymap.set('n', '<leader>s"', builtin.registers, { desc = 'Registers' })
      vim.keymap.set('n', '<leader>sa', builtin.autocommands, { desc = 'Autocmds' })
      vim.keymap.set('n', '<leader>sc', builtin.command_history, { desc = 'Command History' })
      vim.keymap.set('n', '<leader>sC', builtin.commands, { desc = 'Commands' })
      vim.keymap.set('n', '<leader>sD', function()
        builtin.diagnostics { bufnr = 0 }
      end, { desc = 'Buffer Diagnostics' })
      vim.keymap.set('n', '<leader>sH', builtin.highlights, { desc = 'Highlights' })
      vim.keymap.set('n', '<leader>sj', builtin.jumplist, { desc = 'Jumps' })
      vim.keymap.set('n', '<leader>sl', builtin.loclist, { desc = 'Location List' })
      vim.keymap.set('n', '<leader>sM', builtin.man_pages, { desc = 'Man Pages' })
      vim.keymap.set('n', '<leader>sn', extensions.notify.notify, { desc = 'Notification History' })
      vim.keymap.set('n', '<leader>sp', extensions.lazy_plugins.lazy_plugins, { desc = 'Search for Plugin Spec' })
      vim.keymap.set('n', '<leader>sq', builtin.quickfix, { desc = 'Quickfix List' })
      vim.keymap.set('n', '<leader>sS', function() builtin.symbols{ sources = {'emoji'}} end, { desc = "Search Symbols" } )
      vim.keymap.set('n', '<leader>su', extensions.undo.undo, { desc = 'Undo History' })
      vim.keymap.set('n', '<leader>uC', builtin.colorscheme, { desc = 'Colorschemes' })
      vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = 'Goto Definition' })
      vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = 'References' })
      vim.keymap.set('n', 'gI', builtin.lsp_implementations, { desc = 'Goto Implementation' })
      vim.keymap.set('n', 'gy', builtin.lsp_type_definitions, { desc = 'Goto Type Definition' })
      vim.keymap.set('n', '<leader>sS', builtin.lsp_workspace_symbols, { desc = 'LSP Workspace Symbols' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        buffer_fuzzy_find()
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', grep_open_files, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
