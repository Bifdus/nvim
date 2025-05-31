-- local wk = require 'which-key'
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------

-- Disabled/Modified Defaults

-- Disable default s functionality as it conflicts with Flash
vim.keymap.set({ "n", "x" }, "s", "<Nop>")
vim.keymap.set({ "n", "x" }, "S", "<Nop>")

-- NOTE: If you aren't using colemak, comment these out
-- Moves through display-lines, unless count is provided
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

-- Repurpose hjkl for window switching
vim.keymap.set("n", "l", "<c-w>h", { noremap = true })
vim.keymap.set("n", "h", "<c-w>l", { noremap = true })
vim.keymap.set("n", "j", "<c-w>k", { noremap = true })
vim.keymap.set("n", "k", "<c-w>j", { noremap = true })

-----------------------------------------------------------------------------

-- Shift tab to dedent
vim.keymap.set("i", "<S-Tab>", "<C-d>", { noremap = true, silent = true })
-- save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
-- Quit
vim.keymap.set("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit All" })

-- Always use very magic mode for searching
vim.keymap.set("n", "/", [[/\v]])

-- Compare Split Windows
-- wk.add { '<leader>wc', '<cmd>windo diffthis<cr>', desc = '[c]ompare [w]indows', mode = 'n', icon = { icon = '󰆊', color = 'green' } }

-----------------------------------------------------------------------------
-- Chainsaw logging Plugin

-- log the name & value of the variable under the cursor
vim.keymap.set(
	"n",
	"<leader>clv",
	'<cmd>lua require("chainsaw").variableLog() <CR>',
	{ noremap = true, silent = true, desc = "[c]hainsaw [l]og [v]ariable" }
)

-- like variableLog, but with syntax specific to inspect an object such as
-- `console.log(JSON.stringify(foobar))` in javascript
vim.keymap.set(
	"n",
	"<leader>clo",
	'<cmd>lua require("chainsaw").objectLog()<CR>',
	{ noremap = true, silent = true, desc = "[c]hainsaw [l]og [o]bject" }
)

-- inspect the type of the variable under cursor, such as `typeof foo` in js
vim.keymap.set(
	"n",
	"<leader>clt",
	'<cmd>lua require("chainsaw").typeLog()<CR>',
	{ noremap = true, silent = true, desc = "[c]hainsaw [l]og [t]ype" }
)

-- assertion statement for variable under cursor
vim.keymap.set(
	"n",
	"<leader>cla",
	'<cmd>lua require("chainsaw").assertLog()<CR>',
	{ noremap = true, silent = true, desc = "[c]hainsaw [l]og [a]ssert" }
)

-- Minimal log statement, with an emoji for differentiation. Intended for
-- control flow inspection, i.e. to quickly glance whether a condition was
-- triggered or not. (Inspired by AppleScript's `beep` command.)
vim.keymap.set(
	"n",
	"<leader>clb",
	'<cmd>lua require("chainsaw").beepLog()<CR>',
	{ noremap = true, silent = true, desc = "[c]hainsaw [l]og [b]eep" }
)

-- create log statement, and position the cursor to enter a message
vim.keymap.set(
	"n",
	"<leader>clm",
	'<cmd>lua require("chainsaw").messageLog()<CR>',
	{ noremap = true, silent = true, desc = "[c]hainsaw [l]og [m]essage" }
)

-- 1st call: start measuring the time
-- 2nd call: logs the time duration since
vim.keymap.set(
	"n",
	"<leader>clT",
	'<cmd>lua require("chainsaw").timeLog()<CR>',
	{ noremap = true, silent = true, desc = "[c]hainsaw [l]og [T]ime" }
)

-- debug statements like `debugger` in javascript or `breakpoint()` in python
vim.keymap.set(
	"n",
	"<leader>cld",
	'<cmd>lua require("chainsaw").debugLog()<CR>',
	{ noremap = true, silent = true, desc = "[c]hainsaw [l]og [d]ebug" }
)

-- prints the stacktrace of the current call
vim.keymap.set(
	"n",
	"<leader>cls",
	'<cmd>lua require("chainsaw").stacktraceLog()<CR>',
	{ noremap = true, silent = true, desc = "[c]hainsaw [l]og [s]tackTrace" }
)

-- clearing statement, such as `console.clear()`
vim.keymap.set(
	"n",
	"<leader>clc",
	'<cmd>lua require("chainsaw").clearLog()<CR>',
	{ noremap = true, silent = true, desc = "[c]hainsaw [l]og [c]lear" }
)

-- remove all log statements created by chainsaw
vim.keymap.set(
	"n",
	"<leader>clr",
	'<cmd>lua require("chainsaw").removeLogs()<CR>',
	{ noremap = true, silent = true, desc = "[c]hainsaw [l]og [r]emove" }
)
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

-----------------------------------------------------------------------------
--- End Chainsaw mappings

-----------------------------------------------------------------------------
--- Minty color picker
vim.keymap.set("n", "<leader>pc", "<cmd>Huefy<cr>")
vim.keymap.set("n", "<leader>ps", "<cmd>Shades<cr>")

-----------------------------------------------------------------------------
--- Spider
vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
