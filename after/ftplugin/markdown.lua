vim.opt_local.foldmethod = "manual"
vim.opt_local.foldlevel = 99
vim.opt_local.foldenable = true

vim.keymap.set("x", "<leader>one", function()
  local mod = require("util.obsidian")
  local selection = mod.get_linewise_selection_and_range()

  mod.extract_to_templated_note(selection)
end)

-- Keep the document outline through this heading level and fold everything
-- below it. `closeFoldsWith()` preserves UFO's foldlevel=99, so edits do not
-- unexpectedly re-fold the document.
for level = 1, 3 do
  vim.keymap.set("n", "<leader>on" .. level, function()
    require("ufo").closeFoldsWith(level)
  end, {
    buffer = true,
    desc = ("Obsidian: show through H%d"):format(level),
  })
end
