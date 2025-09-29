return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = { enabled = false },
        ts_ls = { enabled = false },
        angular_ls = { enabled = false },

        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            complete_function_calls = false,
            vtsls = {
              enableMoveToFileCodeAction = true,
              suggest = { completeFunctionCalls = false },
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = { enableServerSideFuzzyMatch = true },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = { completeFunctionCalls = false },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },

          keys = {
            {
              "gD",
              function()
                local params = vim.lsp.util.make_position_params()
                Core.lsp.execute({
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position },
                  open = true,
                })
              end,
              desc = "Goto Source Definition",
            },
            {
              "gR",
              function()
                Core.lsp.execute({
                  command = "typescript.findAllFileReferences",
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                })
              end,
              desc = "File References",
            },
            { "<leader>to", Core.lsp.action["source.organizeImports.ts"], desc = "Organize Imports" },
            { "<leader>ta", Core.lsp.action["source.addMissingImports.ts"], desc = "Add missing imports" },
            { "<leader>tr", Core.lsp.action["source.removeUnused.ts"], desc = "Remove unused imports" },
            { "<leader>tf", Core.lsp.action["source.fixAll.ts"], desc = "Fix all diagnostics" },
            {
              "<leader>cV",
              function()
                Core.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
              end,
              desc = "Select TS workspace version",
            },
          },
        },
      },

      setup = {
        tsserver = function()
          return true
        end,
        ts_ls = function()
          return true
        end,

        vtsls = function(_, opts)
          local keys = opts.keys or {}

          Core.lsp.on_attach(function(client, buffer)
            if client.name ~= "vtsls" then
              return
            end

            for _, keymap in ipairs(keys) do
              local lhs, rhs = keymap[1], keymap[2]
              if lhs and rhs then
                local mode = keymap.mode or "n"
                local map_opts =
                  vim.tbl_deep_extend("force", { buffer = buffer, silent = true, noremap = true }, keymap)
                map_opts[1], map_opts[2], map_opts.mode = nil, nil, nil
                map_opts.ft, map_opts.has = nil, nil
                vim.keymap.set(mode, lhs, rhs, map_opts)
              end
            end

            client.commands["_typescript.moveToFileRefactoring"] = function(command)
              local action, uri, range = unpack(command.arguments) ---@type string, string, lsp.Range
              local function move(newf)
                client:request("workspace/executeCommand", {
                  command = command.command,
                  arguments = { action, uri, range, newf },
                })
              end
              local fname = vim.uri_to_fname(uri)
              client:request("workspace/executeCommand", {
                command = "typescript.tsserverRequest",
                arguments = {
                  "getMoveToRefactoringFileSuggestions",
                  {
                    file = fname,
                    startLine = range.start.line + 1,
                    startOffset = range.start.character + 1,
                    endLine = range["end"].line + 1,
                    endOffset = range["end"].character + 1,
                  },
                },
              }, function(_, result)
                local files = result.body.files ---@type string[]
                table.insert(files, 1, "Enter new path...")
                vim.ui.select(files, {
                  prompt = "Select move destination:",
                  format_item = function(f)
                    return vim.fn.fnamemodify(f, ":~:.")
                  end,
                }, function(f)
                  if f and f:find("^Enter new path") then
                    vim.ui.input({
                      prompt = "Enter move destination:",
                      default = vim.fn.fnamemodify(fname, ":h") .. "/",
                      completion = "file",
                    }, function(newf)
                      return newf and move(newf)
                    end)
                  elseif f then
                    move(f)
                  end
                end)
              end)
            end
          end)

          opts.keys = nil
          opts.on_attach = nil

          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})

          -- Mason v2 will auto enable
          return false
        end,
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "css", "javascript", "typescript", "typescriptreact", "javascriptreact" },
    event = "VeryLazy",
    opts = {},
  },

  { "nvchad/volt", lazy = false },
  {
    "nvchad/minty",
    opts = { filetypes = { "css", "html", "typescript", "javascript", "tsx", "ts", "jsx" } },
    config = function(_, opts)
      require("minty").setup(opts)
    end,
  },
}
