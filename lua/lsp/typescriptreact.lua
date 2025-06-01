return {
	-----------------------------------------------------------------------------
	-- Better typescript lsp
	{
		"pmizio/typescript-tools.nvim",
		ft = { "html", "css", "javascript", "typescript", "typescriptreact", "javascriptreact" },
		dependencies = { "nvim-lua/plenary.nvim", "SmiteshP/nvim-navic" },
		opts = {
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

				if client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, bufnr)
				end

				local opts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "<leader>ttr", "<cmd>TSToolsRenameFile<CR>", opts)
				vim.keymap.set("n", "<leader>tti", "<cmd>TSToolsOrganizeImports<CR>", opts)
				vim.keymap.set("n", "<leader>tto", "<cmd>TSToolsSortImports<CR>", opts)
				vim.keymap.set("n", "<leader>tta", "<cmd>TSToolsAddMissingImports<CR>", opts)
			end,
		},
		config = function(_, opts)
			require("typescript-tools").setup(opts)
		end,
	},

	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"neovim/nvim-lspconfig",
		},
		opts = {},
	},

	-- Tags typescript
	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "css", "javascript", "typescript", "typescriptreact", "javascriptreact" },
		event = "VeryLazy",
		opts = {},
	},

	{ "nvchad/volt", lazy = false },
	{
		"nvchad/minty",
		opts = { filetypes = { "css", "html", "typescript", "javascript", "tsx", "ts", "jsx" } },
		config = function(_, opts)
			require("minty").setup(opts)
		end,
	},

	-----------------------------------------------------------------------------
	-- Comments, with context
	{
		"numToStr/Comment.nvim",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		ft = { "javascriptreact", "typescriptreact" },
		keys = {
			{
				"<Leader>V",
				"<Plug>(comment_toggle_blockwise_current)",
				mode = "n",
				desc = "Comment",
				ft = { "typescriptreact", "javascriptreact" },
			},
			{
				"<Leader>V",
				"<Plug>(comment_toggle_blockwise_visual)",
				mode = "x",
				desc = "Comment",
				ft = { "typescriptreact", "javascriptreact" },
			},
		},
		opts = function(_, opts)
			local ok, tcc = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
			if ok then
				opts.pre_hook = tcc.create_pre_hook()
			end
		end,
	},
}
