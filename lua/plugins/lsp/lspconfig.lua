-- LSP Plugins
return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    config = false,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim", config = function() end },
    },
    opts = function()
      local ret = {
        diagnostics = {
          underline = false,
          update_in_insert = false,
        },
        severity_sort = true,
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
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        } or {},
        inlay_hints = {
          enabled = true,
        },
        float = { border = "rounded", source = "if_many" },
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        servers = {
          lua_ls = {
            settings = {
              Lua = {
                checkThirdParty = false,
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
        },
        setup = {},
      }
      return ret
    end,

    config = function(_, opts)
      local base_caps = vim.lsp.protocol.make_client_capabilities()
      local cmp_caps = require("cmp_nvim_lsp").default_capabilities(base_caps)
      local global_capabilities = vim.tbl_deep_extend("force", {}, cmp_caps, opts.capabilities or {})
      vim.lsp.config("*", { capabilities = global_capabilities })

      local mason_map = require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package
      local mason_exclude = {}

      local function setup_one(name, sopts)
        local handled = opts.setup[name] and opts.setup[name](name, sopts)

        if handled then
          table.insert(mason_exclude, name)
          return
        end

        local server_opts = vim.tbl_deep_extend("force", {}, sopts or {})
        server_opts.enabled = nil
        server_opts.capabilities = vim.tbl_deep_extend("force", {}, global_capabilities, server_opts.capabilities or {})

        vim.lsp.config(name, server_opts)
        if not mason_map[name] then
          vim.lsp.enable(name)
        end
      end

      for name, sopts in pairs(opts.servers or {}) do
        if sopts ~= false and (type(sopts) ~= "table" or sopts.enabled ~= false) then
          setup_one(name, type(sopts) == "table" and vim.tbl_deep_extend("force", {}, sopts or {}))
        end
      end

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_enable = { exclude = mason_exclude },
      })
    end,
  },

  --   config = function()
  --     local capabilities = require("cmp_nvim_lsp").default_capabilities()
  --     vim.lsp.config("*", { capabilities = capabilities })
  --
  --     -- This autocommand runs whenever an LSP attaches to a buffer.
  --     vim.api.nvim_create_autocmd("LspAttach", {
  --       group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  --       callback = function(event)
  --         local map = function(keys, func, desc, mode)
  --           mode = mode or "n"
  --           vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
  --         end
  --
  --         map("<leader>rn", "<cmd>Lspsaga rename<CR>", "[R]e[n]ame")
  --         map("<leader>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ction", { "n", "x" })
  --         map("K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")
  --         map("<c-k>", "<cmd>Lspsaga peek_type_definition<CR>", "Type [D]efinition")
  --         map("gh", "<cmd>Lspsaga lsp_finder<CR>", "LSP Finder")
  --         map("gp", "<cmd>Lspsaga peek_definition<CR>", "Peek Definition")
  --         map("go", "<cmd>Lspsaga outline<CR>", "Goto outline")
  --
  --         local function client_supports_method(client, method, bufnr)
  --           if vim.fn.has("nvim-0.11") == 1 then
  --             return client:supports_method(method, bufnr)
  --           else
  --             return client.supports_method(method, { bufnr = bufnr })
  --           end
  --         end
  --
  --         local client = vim.lsp.get_client_by_id(event.data.client_id)
  --
  --         if
  --           client
  --           and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
  --         then
  --           local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
  --           vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  --             buffer = event.buf,
  --             group = highlight_augroup,
  --             callback = vim.lsp.buf.document_highlight,
  --           })
  --           vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  --             buffer = event.buf,
  --             group = highlight_augroup,
  --             callback = vim.lsp.buf.clear_references,
  --           })
  --
  --           vim.api.nvim_create_autocmd("LspDetach", {
  --             group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
  --             callback = function(event2)
  --               vim.lsp.buf.clear_references()
  --               vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
  --             end,
  --           })
  --         end
  --
  --         if client and client.name == "clangd" then
  --           map("<leader>lh", "<cmd>ClangdSwitchSourceHeader<CR>", "Switch Source/Header")
  --         end
  --
  --         if client and client.name == "tailwindcss" then
  --           map("<leader>Tc", "<cmd>TailwindConcealToggle<CR>", "Toggle Conceal")
  --           map("<leader>Th", "<cmd>TailwindColorToggle<CR>", "Toggle Colors")
  --           map("<leader>Ts", "<cmd>TailwindSort<CR>", "Tailwind sort")
  --           map("<leader>s", "<cmd>TailwindSortSelection<CR>", "Sort selection")
  --           map("<leader>tn", "<cmd>TailwindNextClass<CR>", "NextClass")
  --           map("<leader>tN", "<cmd>TailwindPrevClass<CR>", "Previous class")
  --         end
  --
  --         if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
  --           map("<leader>uh", function()
  --             vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
  --           end, "[T]oggle Inlay [H]ints")
  --         end
  --       end,
  --     })
  --
  --     -- Create the LSP capabilities, enhancing them with cmp_nvim_lsp.
  --     -- NOTE: disabled due to using cmp
  --     -- local capabilities = require("blink.cmp").get_lsp_capabilities()
  --
  --     -- Define server-specific settings.
  --     local servers = {
  --       basedpyright = {
  --         settings = {
  --           basedpyright = {
  --             disableOrganizeImports = true,
  --             disableTaggedHints = true,
  --             analysis = {
  --               typeCheckingMode = "basic",
  --               autoSearchPaths = true,
  --               useLibraryCodeForTypes = true,
  --               diagnosticMode = "workspace",
  --               diagnosticSeverityOverrides = {
  --                 reportUnusedImport = "none",
  --                 reportAttributeAccessIssue = "none",
  --               },
  --             },
  --           },
  --         },
  --       },
  --       ruff = {
  --         init_options = {
  --           settings = {
  --             lint = {
  --               ignore = {
  --                 "E401",
  --               },
  --             },
  --           },
  --         },
  --       },
  --       yamlls = {},
  --       docker_compose_language_service = {},
  --       bashls = {},
  --       jsonls = { filetypes = { "json", "jsonc" } },
  --       -- sqlls = {
  --       -- 	filetypes = { "sql", "mysql" },
  --       -- 	connections = { driver = "mssql" },
  --       -- },
  --       jdtls = {},
  --       lua_ls = {
  --         settings = {
  --           Lua = {
  --             completion = { callSnippet = "Replace" },
  --           },
  --         },
  --       },
  --       angularls = { enabled = false },
  --       ts_ls = { enabled = false },
  --       vtsls = {
  --         filetypes = {
  --           "javascript",
  --           "javascriptreact",
  --           "javascript.jsx",
  --           "typescript",
  --           "typescriptreact",
  --           "typescript.tsx",
  --         },
  --         settings = {
  --           complete_function_calls = true,
  --           vtsls = {
  --             enableMoveToFileCodeAction = true,
  --             autoUseWorkspaceTsdk = true,
  --             experimental = {
  --               maxInlayHintLength = 30,
  --               completion = {
  --                 enableServerSideFuzzyMatch = true,
  --               },
  --             },
  --           },
  --           typescript = {
  --             updateImportsOnFileMove = { enabled = "always" },
  --             suggest = {
  --               completeFunctionCalls = true,
  --             },
  --             inlayHints = {
  --               enumMemberValues = { enabled = true },
  --               functionLikeReturnTypes = { enabled = true },
  --               parameterNames = { enabled = "literals" },
  --               parameterTypes = { enabled = true },
  --               propertyDeclarationTypes = { enabled = true },
  --               variableTypes = { enabled = false },
  --             },
  --           },
  --         },
  --         keys = {
  --           {
  --             "gD",
  --             function()
  --               local params = vim.lsp.util.make_position_params()
  --               Util.lsp.execute({
  --                 command = "typescript.goToSourceDefinition",
  --                 arguments = { params.textDocument.uri, params.position },
  --                 open = true,
  --               })
  --             end,
  --             desc = "Goto Source Definition",
  --           },
  --           {
  --             "gR",
  --             function()
  --               Util.lsp.execute({
  --                 command = "typescript.findAllFileReferences",
  --                 arguments = { vim.uri_from_bufnr(0) },
  --                 open = true,
  --               })
  --             end,
  --             desc = "File References",
  --           },
  --           {
  --             "<leader>to",
  --             Util.lsp.action["source.organizeImports"],
  --             desc = "Organize Imports",
  --           },
  --           {
  --             "<leader>cM",
  --             Util.lsp.action["source.addMissingImports.ts"],
  --             desc = "Add missing imports",
  --           },
  --           {
  --             "<leader>cu",
  --             Util.lsp.action["source.removeUnused.ts"],
  --             desc = "Remove unused imports",
  --           },
  --           {
  --             "<leader>cD",
  --             Util.lsp.action["source.fixAll.ts"],
  --             desc = "Fix all diagnostics",
  --           },
  --           {
  --             "<leader>cV",
  --             function()
  --               Util.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
  --             end,
  --             desc = "Select TS workspace version",
  --           },
  --         },
  --       },
  --       clangd = {
  --         filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  --       },
  --       -- tailwindcss = {
  --       --   filetypes = { "javascriptreact", "typescriptreact" },
  --       -- },
  --       lemminx = {},
  --       marksman = {
  --         single_file_support = false,
  --         filetypes = { "markdown" },
  --       },
  --       prismals = {},
  --     }
  --
  --     -- Define default options that apply to all servers.
  --     local default_opts = {
  --       capabilities = capabilities,
  --     }
  --
  --     -- Setup Mason and ensure required tools are installed.
  --     require("mason").setup()
  --     local ensure_installed = {}
  --     for server_name, server_opts in pairs(servers or {}) do
  --       if server_opts ~= false and (type(server_opts) ~= "table" or server_opts.enabled ~= false) then
  --         table.insert(ensure_installed, server_name)
  --       end
  --     end
  --     vim.list_extend(ensure_installed, { "stylua", "prettier", "black", "roslyn" })
  --     require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
  --
  --     local configured = {}
  --     local pending_enables ---@type table<string, boolean>?
  --
  --     local function enable_or_defer(name)
  --       if vim.v.vim_did_enter == 1 then
  --         vim.lsp.enable(name)
  --         return
  --       end
  --
  --       if not pending_enables then
  --         pending_enables = {}
  --         vim.api.nvim_create_autocmd("VimEnter", {
  --           once = true,
  --           callback = function()
  --             for server in pairs(pending_enables or {}) do
  --               vim.lsp.enable(server)
  --             end
  --             pending_enables = nil
  --           end,
  --         })
  --       end
  --
  --       pending_enables[name] = true
  --     end
  --
  --     local function setup(server_name)
  --       if configured[server_name] then
  --         return
  --       end
  --
  --       local server_opts = servers[server_name]
  --       if server_opts == false or (type(server_opts) == "table" and server_opts.enabled == false) then
  --         return
  --       end
  --
  --       server_opts = server_opts or {}
  --       if type(server_opts) == "table" then
  --         server_opts = vim.tbl_deep_extend("force", {}, server_opts)
  --         server_opts.enabled = nil
  --       end
  --
  --       configured[server_name] = true
  --
  --       local opts = vim.tbl_deep_extend("force", {}, default_opts, server_opts)
  --       vim.lsp.config(server_name, opts)
  --
  --       if vim.lsp.config[server_name] then
  --         enable_or_defer(server_name)
  --       else
  --         vim.notify(string.format("[lspconfig] unable to resolve LSP config for %s", server_name), vim.log.levels.WARN)
  --       end
  --     end
  --
  --     require("mason-lspconfig").setup({
  --       ensure_installed = {},
  --       automatic_enable = false,
  --     })
  --
  --     for server_name in pairs(servers) do
  --       setup(server_name)
  --     end
  --   end,
  -- },
  -- vim: ts=2 sts=2 sw=2 et
}
