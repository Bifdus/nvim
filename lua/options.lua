vim.filetype.add({
  pattern = {
    ["docker%-compose%.yml$"] = "yaml.docker-compose",
    ["docker%-compose%.yaml$"] = "yaml.docker-compose",
  },
})

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Sets default clip to OS default
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- General Defaults
vim.g.autoformat = false
vim.g.lazygit_config = true
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.undofile = true
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.smarttab = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.scrolloff = 8
-- Splits default behavior
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.relativenumber = true
vim.opt.foldlevelstart = 99

vim.opt.title = true

-- Expand tab
-- Set tab spacing
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.breakindent = true
vim.opt.backspace = { "start", "eol", "indent" }

-- Live viewing of substitute while typing
vim.opt.inccommand = "split"

-- How certain whitespace characters should be displayed in the editor
vim.opt.list = true
vim.opt.listchars = {
  tab = "│─",
  extends = "⟫",
  precedes = "⟪",
  conceal = "",
  nbsp = "␣",
  trail = "·",
}

-- Statusline fill chars
vim.opt.fillchars = {
  foldopen = "", -- 󰅀 
  foldclose = "", -- 󰅂 
  fold = " ", -- ⸱
  foldsep = " ",
  diff = "╱",
  eob = " ",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}
