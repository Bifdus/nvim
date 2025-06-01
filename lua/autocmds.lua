-- Sets the foldmethod upon entering a new Window/Buffer
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	callback = function()
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})

local function augroup(name)
	return vim.api.nvim_create_augroup('bifdus.' .. name, { clear = true })
end

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
	group = augroup('close_with_q'),
	pattern = {
		'blame',
		'fugitive',
		'fugitiveblame',
		'httpResult',
		'lspinfo',
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set('n', 'q', function()
				vim.cmd('close')
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = 'Quit buffer',
			})
		end)
	end,
})
