local M = {}

local obsidian = require("obsidian")
local Note = obsidian.Note

local function normalize_range(start_row, start_col, end_row, end_col)
  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    return end_row, end_col, start_row, start_col
  end
  return start_row, start_col, end_row, end_col
end

local function line_len(bufnr, row)
  return #vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
end

local function clamp(val, min_val, max_val)
  if val < min_val then
    return min_val
  elseif val > max_val then
    return max_val
  end
  return val
end

local function sanitize_range(bufnr, start_row, start_col, end_row, end_col)
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if line_count == 0 then
    return 0, 0, 0, 0
  end

  start_row = clamp(start_row, 0, line_count - 1)
  end_row = clamp(end_row, 0, line_count - 1)

  local start_len = line_len(bufnr, start_row)
  local end_len = line_len(bufnr, end_row)

  start_col = clamp(start_col, 0, start_len)
  end_col = clamp(end_col, 0, end_len)

  start_row, start_col, end_row, end_col =
    normalize_range(start_row, start_col, end_row, end_col)

  return start_row, start_col, end_row, end_col
end

function M.get_visual_selection_and_range()
  local bufnr = vim.api.nvim_get_current_buf()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_row = start_pos[2] - 1
  local start_col = start_pos[3] - 1
  local end_row = end_pos[2] - 1
  local end_col = end_pos[3]

  start_row, start_col, end_row, end_col =
    sanitize_range(bufnr, start_row, start_col, end_row, end_col)

  local lines = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {})
  local text = table.concat(lines, "\n")

  return {
    bufnr = bufnr,
    text = text,
    start_row = start_row,
    start_col = start_col,
    end_row = end_row,
    end_col = end_col,
  }
end

local function split_lines(text)
  return vim.split(text, "\n", { plain = true })
end

local function replace_visual_selection(range, replacement)
  if not vim.api.nvim_buf_is_valid(range.bufnr) then
    vim.notify("Original buffer is no longer valid", vim.log.levels.ERROR)
    return
  end

  local start_row, start_col, end_row, end_col =
    sanitize_range(range.bufnr, range.start_row, range.start_col, range.end_row, range.end_col)

  vim.api.nvim_buf_set_text(
    range.bufnr,
    start_row,
    start_col,
    end_row,
    end_col,
    { replacement }
  )
end

local function inject_content(lines, extracted_text)
  local new_lines = vim.deepcopy(lines)
  local extracted_lines = split_lines(extracted_text)

  if #new_lines > 0 and new_lines[#new_lines] ~= "" then
    new_lines[#new_lines + 1] = ""
  end

  vim.list_extend(new_lines, extracted_lines)
  return new_lines
end

function M.extract_to_templated_note(selection)
  selection = selection or M.get_visual_selection_and_range()

  if not selection.text or vim.trim(selection.text) == "" then
    vim.notify("No visual selection found", vim.log.levels.WARN)
    return
  end

  vim.ui.input({ prompt = "Note title: " }, function(title)
    if not title or vim.trim(title) == "" then
      return
    end

    vim.ui.select({ "fleeting", "reference", "structure", "process", "permanent" }, {
      prompt = "Template:",
    }, function(template_name)
      if not template_name then
        return
      end

      local note = Note.create({
        id = title,
        aliases = {},
        tags = {},
        should_write = false,
        template = template_name,
      })

      local ok, err = pcall(function()
        note:write({
          template = template_name,
          update_content = function(lines)
            return inject_content(lines, selection.text)
          end,
        })
      end)

      if not ok then
        vim.notify("Failed to create note: " .. tostring(err), vim.log.levels.ERROR)
        return
      end

      local link = note:format_link()
      replace_visual_selection(selection, link)

      vim.notify("Extracted selection to " .. note:display_name(), vim.log.levels.INFO)
    end)
  end)
end

return M
