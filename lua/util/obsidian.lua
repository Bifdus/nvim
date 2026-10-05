local M = {}

local obsidian = require("obsidian")
local Note = obsidian.Note

local function split_lines(text)
  return vim.split(text, "\n", { plain = true, trimempty = false })
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
