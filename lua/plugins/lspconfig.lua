-- LSP Plugins
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },

  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {
      {
        "Hoffs/omnisharp-extended-lsp.nvim",
        lazy = true,
      },
      { "williamboman/mason.nvim", config = true, version = "1.11.0" },
      { "williamboman/mason-lspconfig.nvim", version = "1.32.0" },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      -- "saghen/blink.cmp",
    },
    config = function()
      -- This autocommand runs whenever an LSP attaches to a buffer.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- require('lsp_signature').on_attach(_, event.buf)

          map("<leader>D", "<cmd>Lspsaga peek_type_definition<CR>", "Type [D]efinition")
          map("<leader>rn", "<cmd>Lspsaga rename<CR>", "[R]e[n]ame")
          map("<leader>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ction", { "n", "x" })
          map("K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")
          map("<c-k>", "<cmd>Lspsaga peek_type_definition<CR>", "Type [D]efinition")
          map("gh", "<cmd>Lspsaga lsp_finder<CR>", "LSP Finder")
          map("gp", "<cmd>Lspsaga peek_definition<CR>", "Peek Definition")
          map("go", "<cmd>Lspsaga outline<CR>", "Goto outline")

          local function client_supports_method(client, method, bufnr)
            if vim.fn.has("nvim-0.11") == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client
            and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
          then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          if client and client.name == "clangd" then
            map("<leader>lh", "<cmd>ClangdSwitchSourceHeader<CR>", "Switch Source/Header")
          end

          if client and client.name == "tailwindcss" then
            map("<leader>Tc", "<cmd>TailwindConcealToggle<CR>", "Toggle Conceal")
            map("<leader>Th", "<cmd>TailwindColorToggle<CR>", "Toggle Colors")
            map("<leader>Ts", "<cmd>TailwindSort<CR>", "Tailwind sort")
            map("<leader>s", "<cmd>TailwindSortSelection<CR>", "Sort selection")
            map("<leader>tn", "<cmd>TailwindNextClass<CR>", "NextClass")
            map("<leader>tN", "<cmd>TailwindPrevClass<CR>", "Previous class")
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        } or {},
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })

      -- Create the LSP capabilities, enhancing them with cmp_nvim_lsp.
      -- NOTE: disabled due to using cmp
      -- local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Create the LSP capabilities, enhancing them with cmp_nvim_lsp.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      -- Define server-specific settings.
      local servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },
        docker_compose_language_service = {},
        bashls = {},
        jsonls = { filetypes = { "json" } },
        -- sqlls = {
        -- 	filetypes = { "sql", "mysql" },
        -- 	connections = { driver = "mssql" },
        -- },
        jdtls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
            },
          },
        },
        angularls = {},
        phpactor = {
          cmd = { "intelephense", "--stdio" },
          filetypes = { "php" },
          settings = {
            intelephense = {
              environment = { includePaths = { "../symfony/lib", "./lib/model" } },
              files = {
                exclude = {
                  "**/cache/**",
                  "**/vendor/**",
                },
              },
              stubs = { "pdo", "xml", "curl", "spl" },
            },
          },
        },
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        },
        tailwindcss = {
          filetypes = { "javascriptreact", "typescriptreact" },
        },
        lemminx = {},
        marksman = {
          filetypes = { "markdown" },
        },
      }

      -- Define default options that apply to all servers.
      local default_opts = {
        root_dir = require("lspconfig").util.root_pattern(".git"),
        capabilities = capabilities,
      }

      -- Setup Mason and ensure required tools are installed.
      require("mason").setup()
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, { "stylua", "prettier", "black" })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })

      -- Setup each server by merging default options with server-specific overrides.
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local server_opts = servers[server_name] or {}
          local opts = vim.tbl_deep_extend("force", {}, default_opts, server_opts)
          require("lspconfig")[server_name].setup(opts)
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
