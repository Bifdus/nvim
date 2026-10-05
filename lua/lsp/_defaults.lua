local ok, cmp = pcall(require, "cmp_nvim_lsp")
local base = vim.lsp.protocol.make_client_capabilities()
local caps = ok and cmp.default_capabilities(base) or base
-- local caps = require("blink.cmp").get_lsp_capabilities(base) -- when swapping to blink
caps.workspace = caps.workspace or {}
caps.workspace.fileOperations =
  vim.tbl_deep_extend("force", caps.workspace.fileOperations or {}, { didRename = true, willRename = true })

return {
  capabilities = caps,
  on_attach = function(client, bufnr)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
    end

    map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "[R]e[n]ame")
    map({ "n", "x" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ction")
    map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")
    map("n", "<leader>pd", "<cmd>Lspsaga peek_definition<CR>", "Peek [D]efinition")

    -- VTSLS
    if client and client.name == "vtsls" then
      local opts = client.config
      -- Mirror TS settings to JS (seen in Lazyvim)
      if opts and opts.settings then
        opts.settings.javascript =
          vim.tbl_deep_extend("force", {}, opts.settings.typescript or {}, opts.settings.javascript or {})
      end

      local function run_source_action(kind)
        vim.lsp.buf.code_action({
          apply = true,
          context = { only = { kind }, diagnostics = {} },
        })
      end
    -- stylua: ignore start
    map("n", "<leader>to", function() run_source_action("source.organizeImports") end, "TS: Organize Imports")
    map('n', "<leader>ta", function() run_source_action("source.addMissingImports.ts") end, "TS: Add Missing Imports")
    map('n', "<leader>tr", function() run_source_action("source.removeUnused.ts") end, "TS: Remove Unused Imports")
    map('n', "<leader>tf", function() run_source_action("source.fixAll.ts") end, "TS: Fix All")
    end
  end,
}
