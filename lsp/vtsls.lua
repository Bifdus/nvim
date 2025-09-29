---@type vim.lsp.Config
return {
  cmd = { "vtsls", "--stdio" },
  init_options = {
    hostInfo = "neovim",
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_dir = function(bufnr, on_dir)
    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
    -- Give the root markers equal priority by wrapping them in a table
    root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
      or vim.list_extend(root_markers, { ".git" })

    -- We fallback to the current working directory if no project root is found
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

    on_dir(project_root)
  end,

  settings = {
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

  on_attach = function(client, bufnr)
    local opts = client.config
    -- Mirror TS settings to JS (seen in Lazyvim)
    if opts and opts.settings then
      opts.settings.javascript =
        vim.tbl_deep_extend("force", {}, opts.settings.typescript or {}, opts.settings.javascript or {})
    end

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
    end
    local function run_source_action(kind)
      vim.lsp.buf.code_action({
        apply = true,
        context = { only = { kind }, diagnostics = {} },
      })
    end
    -- stylua: ignore start
    map("<leader>to", function() run_source_action("source.organizeImports") end, "TS: Organize Imports")
    map("<leader>ta", function() run_source_action("source.addMissingImports.ts") end, "TS: Add Missing Imports")
    map("<leader>tr", function() run_source_action("source.removeUnused.ts") end, "TS: Remove Unused Imports")
    map("<leader>tf", function() run_source_action("source.fixAll.ts") end, "TS: Fix All")
    -- stylua: ignore end
    --
    --
  end,
}
