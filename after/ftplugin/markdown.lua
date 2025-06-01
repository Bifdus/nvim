-----------------------------------------------------------------------------
-- Markdown Folds

-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
vim.keymap.set('n', '<Tab>', function()
  -- Get the current line number
  local line = vim.fn.line '.'
  -- Get the fold level of the current line
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify('No fold found', vim.log.levels.INFO)
  else
    vim.cmd 'normal! za'
    vim.cmd 'normal! zz' -- center the cursor line on screen
  end
end, { desc = '[P]Toggle fold' })

-- Crate task or checkbox lamw26wmal
-- These are marked with <leader>x using bullets.vim
-- I used <C-l> before, but that is used for pane navigation
vim.keymap.set({ 'n', 'i' }, '<M-c>', function()
  -- Get the current line/row/column
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row, _ = cursor_pos[1], cursor_pos[2]
  local line = vim.api.nvim_get_current_line()
  -- 1) If line is empty => replace it with "- [ ] " and set cursor after the brackets
  if line:match '^%s*$' then
    local final_line = '- [ ] '
    vim.api.nvim_set_current_line(final_line)
    -- "- [ ] " is 6 characters, so cursor col = 6 places you *after* that space
    vim.api.nvim_win_set_cursor(0, { row, 6 })
    return
  end
  -- 2) Check if line already has a bullet with possible indentation: e.g. "  - Something"
  --    We'll capture "  -" (including trailing spaces) as `bullet` plus the rest as `text`.
  local bullet, text = line:match '^([%s]*[-*]%s+)(.*)$'
  if bullet then
    -- Convert bullet => bullet .. "[ ] " .. text
    local final_line = bullet .. '[ ] ' .. text
    vim.api.nvim_set_current_line(final_line)
    -- Place the cursor right after "[ ] "
    -- bullet length + "[ ] " is bullet_len + 4 characters,
    -- but bullet has trailing spaces, so #bullet includes those.
    local bullet_len = #bullet
    -- We want to land after the brackets (four characters: `[ ] `),
    -- so col = bullet_len + 4 (0-based).
    vim.api.nvim_win_set_cursor(0, { row, bullet_len + 4 })
    return
  end
  -- 3) If there's text, but no bullet => prepend "- [ ] "
  --    and place cursor after the brackets
  local final_line = '- [ ] ' .. line
  vim.api.nvim_set_current_line(final_line)
  -- "- [ ] " is 6 characters
  vim.api.nvim_win_set_cursor(0, { row, 6 })
end, { desc = 'Convert bullet to a task or insert new task bullet' })

-----------------------------------------------------------------------------
