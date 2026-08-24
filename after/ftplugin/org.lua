-- Let Orgmode apply `org_startup_folded = "content"`, then freeze the result
-- after the window opens.  Neovim restores the previous cursor position at
-- that point and otherwise opens the fold containing it.
local buf = vim.api.nvim_get_current_buf()
local group = vim.api.nvim_create_augroup("org_startup_manual_folds_" .. buf, { clear = true })

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = group,
  buffer = buf,
  once = true,
  callback = function()
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= "org" then
        return
      end

      for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.api.nvim_win_call(win, function()
          vim.wo.foldenable = true
          vim.wo.foldlevel = 1
          vim.opt_local.foldmethod = "manual"
        end)
      end
    end)
  end,
})
