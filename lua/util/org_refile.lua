local M = {}

local function outline_path(headline)
  local parts = {}
  while headline do
    table.insert(parts, 1, headline.title)
    headline = headline.parent
  end
  return table.concat(parts, " › ")
end

local function is_within_source(source, destination, destination_file)
  if source.file.filename ~= destination_file.filename then
    return false
  end

  return destination.position.start_line >= source.position.start_line
    and destination.position.end_line <= source.position.end_line
end

function M.pick_destination()
  if vim.bo.filetype ~= "org" then
    vim.notify("Org refile is only available in Org buffers", vim.log.levels.WARN)
    return
  end

  local api = require("orgmode.api")
  local source_file = api.current()
  local source = source_file:get_closest_headline()
  if not source then
    vim.notify("Place the cursor on an Org headline to refile it", vim.log.levels.WARN)
    return
  end
  -- Orgmode's public API only assigns `file` to top-level headlines.  Supply
  -- it for nested source headings so refiling a child works as well.
  source.file = source.file or source_file

  local items = {}
  local destinations = {}
  for _, file in ipairs(api.load()) do
    if not file.is_archive_file then
      for _, destination in ipairs(file.headlines) do
        if destination.todo_type ~= "DONE" and not destination.is_archived and not is_within_source(source, destination, file) then
          local todo = destination.todo_value and (destination.todo_value .. " ") or ""
          local id = #destinations + 1
          destination.file = file
          destinations[id] = destination
          table.insert(items, {
            text = string.format(
              "%s%s  [%s · H%d:%d]",
              todo,
              outline_path(destination),
              vim.fn.fnamemodify(file.filename, ":~:."),
              destination.level,
              destination.position.start_line
            ),
            destination_id = id,
          })
        end
      end
    end
  end

  if #items == 0 then
    vim.notify("No eligible Org refile destinations found", vim.log.levels.WARN)
    return
  end

  Snacks.picker({
    title = "Org Refile Destination",
    items = items,
    format = "text",
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end

      api.refile({ source = source, destination = destinations[item.destination_id] }):catch(function(err)
        vim.notify("Org refile failed: " .. tostring(err), vim.log.levels.ERROR)
      end)
    end,
  })
end

return M
