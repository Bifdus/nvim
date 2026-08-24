vim.o.foldmethod = "manual"

vim.keymap.set("x", "<leader>one", function()
  local mod = require("util.obsidian")
  local selection = mod.get_linewise_selection_and_range()

  mod.extract_to_templated_note(selection)
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt_local.foldlevel = 99
  end,
})
