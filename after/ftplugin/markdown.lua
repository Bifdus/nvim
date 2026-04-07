vim.o.foldmethod = "manual"

vim.keymap.set("x", "<leader>one", function()
  local mod = require("util.obsidian")
  local selection = mod.get_linewise_selection_and_range()

  mod.extract_to_templated_note(selection)
end)
