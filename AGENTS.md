# AGENTS.md

Personal Neovim config. Lua, lazy.nvim, native `vim.lsp.config` (no lspconfig).

## Layout

- `init.lua`: load order is options, lazy bootstrap, `_G.Util`, plugins, `lsp`, keymaps, autocmds.
- `lua/plugins/*.lua`, `lua/plugins/lang/*.lua`: lazy.nvim specs, one area per file. Auto-imported.
- `lua/util/`: helpers, exposed globally as `Util.*` via `lua/util/init.lua`.
- `lua/lsp/init.lua`: diagnostics config, shared defaults, `servers` list to enable.
- `lsp/<server>.lua`: per-server config table (runtime path lookup by `vim.lsp.enable`).
- `after/ftplugin/`: filetype-local settings.
- `lazy-lock.json`: plugin pins. Only touch when updating plugins.

## Conventions

- Format with stylua (`.stylua.toml`: 2 spaces).
- New server: add `lsp/<name>.lua`, then add name to `servers` in `lua/lsp/init.lua`.
- New plugin: add spec to the matching `lua/plugins/` file; new file only for a new area.
- Reuse `Util.*` helpers before writing new ones.
- Commits: conventional style, e.g. `feat(notes): ...`, `feat(lsp): ...`.

## Check

`nvim --headless "+qa"` should exit with no errors.
