local M = {}

local obsidian = require("obsidian")
local Note = obsidian.Note

local CTRL_V = vim.api.nvim_replace_termcodes("<C-v>", true, false, true)

local function clamp(x, minv, maxv)
  if x < minv then
    return minv
  elseif x > maxv then
    return maxv
  end
  return x
end

local function line_count(bufnr)
  return vim.api.nvim_buf_line_count(bufnr)
end

local function get_line(bufnr, row)
  local lines = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)
  return lines[1] or ""
end

local function line_len(bufnr, row)
  return #get_line(bufnr, row)
end

local function get_mark(mark)
  local pos = vim.fn.getpos(mark)
  return pos[2] - 1, pos[3] - 1
end

local function split_lines(text)
  return vim.split(text, "\n", { plain = true, trimempty = false })
end

local function current_visual_type()
  local mode = vim.fn.mode(1)

  if mode == "V" then
    return "line"
  end

  if mode == CTRL_V or mode == "\22" then
    return "block"
  end

  if mode == "v" or mode == "vs" or mode == "s" then
    return "char"
  end

  local ok, vmode = pcall(vim.fn.visualmode)
  if ok then
    if vmode == "V" then
      return "line"
    end
    if vmode == CTRL_V or vmode == "\22" then
      return "block"
    end
  end

  return "char"
end

local function normalize_rows(start_row, end_row)
  if start_row > end_row then
    return end_row, start_row
  end
  return start_row, end_row
end

local function normalize_range(sr, sc, er, ec)
  if sr > er or (sr == er and sc > ec) then
    return er, ec, sr, sc
  end
  return sr, sc, er, ec
end

local function extract_linewise(bufnr, start_row, end_row)
  local lc = line_count(bufnr)
  if lc == 0 then
    return {
      bufnr = bufnr,
      text = "",
      start_row = 0,
      start_col = 0,
      end_row = 0,
      end_col = 0,
      selection_type = "line",
    }
  end

  start_row = clamp(start_row, 0, lc - 1)
  end_row = clamp(end_row, 0, lc - 1)
  start_row, end_row = normalize_rows(start_row, end_row)

  local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)

  return {
    bufnr = bufnr,
    text = table.concat(lines, "\n"),
    start_row = start_row,
    start_col = 0,
    end_row = end_row,
    end_col = line_len(bufnr, end_row),
    selection_type = "line",
  }
end

local function extract_charwise(bufnr, start_row, start_col, end_row, end_col)
  local lc = line_count(bufnr)
  if lc == 0 then
    return {
      bufnr = bufnr,
      text = "",
      start_row = 0,
      start_col = 0,
      end_row = 0,
      end_col = 0,
      selection_type = "char",
    }
  end

  start_row = clamp(start_row, 0, lc - 1)
  end_row = clamp(end_row, 0, lc - 1)

  start_col = clamp(start_col, 0, line_len(bufnr, start_row))
  end_col = clamp(end_col, 0, line_len(bufnr, end_row))

  start_row, start_col, end_row, end_col = normalize_range(start_row, start_col, end_row, end_col)

  -- marks are inclusive; get_text end_col is exclusive
  end_col = math.min(end_col + 1, line_len(bufnr, end_row))

  local lines = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {})

  return {
    bufnr = bufnr,
    text = table.concat(lines, "\n"),
    start_row = start_row,
    start_col = start_col,
    end_row = end_row,
    end_col = end_col,
    selection_type = "char",
  }
end

local function extract_blockwise(bufnr, start_row, start_col, end_row, end_col)
  local lc = line_count(bufnr)
  if lc == 0 then
    return {
      bufnr = bufnr,
      text = "",
      start_row = 0,
      start_col = 0,
      end_row = 0,
      end_col = 0,
      selection_type = "block",
    }
  end

  start_row = clamp(start_row, 0, lc - 1)
  end_row = clamp(end_row, 0, lc - 1)
  start_row, end_row = normalize_rows(start_row, end_row)

  local left = math.min(start_col, end_col)
  local right = math.max(start_col, end_col)

  local out = {}

  for row = start_row, end_row do
    local line = get_line(bufnr, row)
    local len = #line

    if left > len then
      table.insert(out, "")
    else
      table.insert(out, line:sub(left + 1, math.min(right + 1, len)))
    end
  end

  return {
    bufnr = bufnr,
    text = table.concat(out, "\n"),
    start_row = start_row,
    start_col = left,
    end_row = end_row,
    end_col = right + 1,
    selection_type = "block",
  }
end

function M.get_visual_selection_and_range()
  local bufnr = vim.api.nvim_get_current_buf()
  local start_row, start_col = get_mark("'<")
  local end_row, end_col = get_mark("'>")
  local seltype = current_visual_type()

  if seltype == "line" then
    return extract_linewise(bufnr, start_row, end_row)
  elseif seltype == "block" then
    return extract_blockwise(bufnr, start_row, start_col, end_row, end_col)
  else
    return extract_charwise(bufnr, start_row, start_col, end_row, end_col)
  end
end

local function replace_selection(selection, replacement)
  if not selection or not vim.api.nvim_buf_is_valid(selection.bufnr) then
    vim.notify("Original buffer is no longer valid", vim.log.levels.ERROR)
    return false
  end

  if selection.selection_type == "block" then
    vim.notify("Blockwise visual selections cannot be safely replaced with a single link", vim.log.levels.WARN)
    return false
  end

  local replacement_lines = split_lines(replacement)

  if selection.selection_type == "line" then
    vim.api.nvim_buf_set_lines(selection.bufnr, selection.start_row, selection.end_row + 1, false, replacement_lines)
    return true
  end

  vim.api.nvim_buf_set_text(
    selection.bufnr,
    selection.start_row,
    selection.start_col,
    selection.end_row,
    selection.end_col,
    replacement_lines
  )

  return true
end

function M.get_linewise_selection_and_range()
  local bufnr = vim.api.nvim_get_current_buf()

  local row1 = vim.fn.line("v") - 1
  local row2 = vim.fn.line(".") - 1

  if row1 > row2 then
    row1, row2 = row2, row1
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, row1, row2 + 1, false)

  return {
    bufnr = bufnr,
    text = table.concat(lines, "\n"),
    start_row = row1,
    start_col = 0,
    end_row = row2,
    end_col = 0,
    selection_type = "line",
  }
end

local function exit_visual_mode()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

local function inject_content(lines, extracted_text)
  local new_lines = vim.deepcopy(lines)
  local extracted_lines = split_lines(extracted_text)

  if extracted_text == nil or extracted_text == "" then
    return new_lines
  end

  if #new_lines > 0 and new_lines[#new_lines] ~= "" then
    table.insert(new_lines, "")
  end

  vim.list_extend(new_lines, extracted_lines)
  return new_lines
end

function M.extract_to_templated_note(selection)
  if not selection then
    selection = M.get_visual_selection_and_range()
  end

  if not selection then
    vim.notify("Failed to capture visual selection", vim.log.levels.WARN)
    return
  end

  if not selection.text or vim.trim(selection.text) == "" then
    vim.notify("No visual selection found", vim.log.levels.WARN)
    return
  end

  vim.ui.input({ prompt = "Note title: " }, function(title)
    if not title or vim.trim(title) == "" then
      return
    end

    local client = obsidian.get_client()
    local templates_dir = client and client.opts and client.opts.templates and client.opts.templates.folder

    vim.ui.input({
      prompt = templates_dir and ("Template in " .. templates_dir .. ": ") or "Template: ",
    }, function(template_name)
      if not template_name or vim.trim(template_name) == "" then
        return
      end

      template_name = vim.trim(template_name)

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
      local replaced = replace_selection(selection, link)

      if replaced then
        exit_visual_mode()
        vim.notify("Extracted selection to " .. note:display_name(), vim.log.levels.INFO)
      else
        vim.notify("Note created, but original selection was not replaced", vim.log.levels.WARN)
      end
    end)
  end)
end

return M
