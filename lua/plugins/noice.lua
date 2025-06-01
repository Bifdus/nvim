return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		enabled = true,
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
      -- stylua: ignore
      keys = {
              -- { '<leader>sn', '', desc = '+noice' },
              -- { '<S-Enter>', function() require('noice').redirect(tostring(vim.fn.getcmdline())) end, mode = 'c', desc = 'Redirect Cmdline' },
              -- { '<leader>snl', function() require('noice').cmd('last') end, desc = 'Noice Last Message' },
              -- { '<leader>snh', function() require('noice').cmd('history') end, desc = 'Noice History' },
              { '<leader>sna', function() require('noice').cmd('all') end, desc = 'Noice All' },
              -- { '<leader>snt', function() require('noice').cmd('pick') end, desc = 'Noice Picker (Telescope/FzfLua)' },
      },
		---@type NoiceConfig
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			messages = {
				view_search = false,
			},
			routes = {
				-- See :h ui-messages
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "^%d+ changes?; after #%d+" },
							{ find = "^%d+ changes?; before #%d+" },
							{ find = "^Hunk %d+ of %d+$" },
							{ find = "^%d+ fewer lines;?" },
							{ find = "^%d+ more lines?;?" },
							{ find = "^%d+ line less;?" },
							{ find = "^Already at newest change" },
							{ kind = "wmsg" },
							{ kind = "emsg", find = "E486" },
							{ kind = "quickfix" },
						},
					},
					view = "mini",
				},
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "^%d+ lines .ed %d+ times?$" },
							{ find = "^%d+ lines yanked$" },
							{ kind = "emsg", find = "E490" },
							{ kind = "search_count" },
						},
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "notify",
						any = {
							{ find = "^No code actions available$" },
							{ find = "^No information available$" },
						},
					},
					view = "mini",
				},
				{
					filter = {
						event = "notify",
						any = {
							{ find = "# Config Change Detected. Reloading" },
							{ find = "/warn" },
						},
					},
					opts = { skip = true },
				},
			},
		},
		config = function(_, opts)
			-- HACK: noice shows messages from before it was enabled,
			-- but this is not ideal when Lazy is installing plugins,
			-- so clear the messages in this case.
			if vim.o.filetype == "lazy" then
				vim.cmd([[messages clear]])
			end
			require("noice").setup(opts)
		end,
	},
}
