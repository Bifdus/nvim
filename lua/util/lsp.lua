local M = {}

M.lsp_to_mason = {
  lua_ls = "lua-language-server",
  vtsls = "vtsls",
  basedpyright = "basedpyright",
  yamlls = "yaml-language-server",
  bashls = "bash-language-server",
  clangd = "clangd",
  ruff = "ruff",
  tailwind = "tailwindcss-language-server",
  pasls = "pascal-language-server",
}

M.extra_tools = {
  "eslint_d",
  "prettier",
  "stylua",
  "shfmt",
  "ruff",
  "black",
  "isort",
}

function M.ensure_list()
  local list = {}
  for _, mason_name in pairs(M.lsp_to_mason) do
    table.insert(list, mason_name)
  end
  for _, t in ipairs(M.extra_tools) do
    table.insert(list, t)
  end
  return list
end

-- Tailwind
function M.insert_package_json(root_files, field, fname)
  return M.root_markers_with_field(root_files, { "package.json", "package.json5" }, field, fname)
end

--- Appends `new_names` to `root_files` if `field` is found in any such file in any ancestor of `fname`.
---
--- NOTE: this does a "breadth-first" search, so is broken for multi-project workspaces:
--- https://github.com/neovim/nvim-lspconfig/issues/3818#issuecomment-2848836794
---
--- @param root_files string[] List of root-marker files to append to.
--- @param new_names string[] Potential root-marker filenames (e.g. `{ 'package.json', 'package.json5' }`) to inspect for the given `field`.
--- @param field string Field to search for in the given `new_names` files.
--- @param fname string Full path of the current buffer name to start searching upwards from.
function M.root_markers_with_field(root_files, new_names, field, fname)
  local path = vim.fn.fnamemodify(fname, ":h")
  local found = vim.fs.find(new_names, { path = path, upward = true, type = "file" })

  for _, f in ipairs(found or {}) do
    -- Match the given `field`.
    for line in io.lines(f) do
      if line:find(field) then
        root_files[#root_files + 1] = vim.fs.basename(f)
        break
      end
    end
  end

  return root_files
end

--- Build a `root_dir` callback that prefers marker-based project roots and
--- still attaches for standalone files by falling back to the file's parent dir.
---
--- @param root_markers (string|string[])[]
--- @param opts? { fallback: '"cwd"'|fun(bufnr: integer, fname: string): string? }
--- @return fun(bufnr: integer, on_dir: fun(root_dir?: string))
function M.root_dir_with_fallback(root_markers, opts)
  opts = opts or {}

  return function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = fname ~= "" and vim.fs.root(fname, root_markers) or nil

    if root then
      on_dir(root)
      return
    end

    if type(opts.fallback) == "function" then
      on_dir(opts.fallback(bufnr, fname))
      return
    end

    if opts.fallback == "cwd" or fname == "" then
      on_dir(vim.uv.cwd())
      return
    end

    on_dir(vim.fs.dirname(fname))
  end
end

return M
