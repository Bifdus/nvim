-- Placeholder in case more default config required
local caps = require("lsp._caps").make()

return {
  capabilities = caps,
  on_attach = function(client, bufnr)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
    end

    map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "[R]e[n]ame")
    map({ "n", "x" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ction")
    map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")
    map("n", "<c-k>", "<cmd>Lspsaga peek_type_definition<CR>", "Type [D]efinition")

    -- VTSLS
    if client and client.name == "vtsls" then
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
    end
  end,
}
