return {
	{
		"stevearc/aerial.nvim",
		opts = {
			on_attach = function(bufnr)
				-- Jump forwards/backwards with '{' and '}'
				vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
				vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
			end,
		},
		config = function(_, opts)
			require("aerial").setup(opts)
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},

	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost" },
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Jump to next git [c]hange" })

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Jump to previous git [c]hange" })

				map("n", "<leader>ub", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
				map("n", "<leader>uD", gitsigns.preview_hunk_inline, { desc = "[T]oggle git show [D]eleted" })
			end,
		},
	},

	-----------------------------------------------------------------------------
	-- Quick log lines with smart variable identification, only python, lua and JS
	{
		"chrisgrieser/nvim-chainsaw",
		opts = {
			logStatements = {
				variableLog = {
					nvim_lua = 'vim.notify("%s %s", vim.inspect(%s))',
				},
			},
		},
	},

	-- GIT
	{
		"akinsho/git-conflict.nvim",
		event = "BufReadPost",
		version = "*",
		config = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "GitConflictDetected",
				callback = function()
					vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
				end,
			})

			require("git-conflict").setup({
				debug = true,
				default_mappings = true, -- disable buffer local mapping created by this plugin
				default_commands = true, -- disable commands created by this plugin
				disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
				list_opener = "copen", -- command or function to open the conflicts list
				highlights = { -- They must have background color, otherwise the default color will be used
					incoming = "DiffText",
					current = "DiffAdd",
				},
			})
		end,
		keys = {
			{ "<Leader>gcb", "<cmd>GitConflictChooseBoth<CR>", desc = "choose both" },
			{ "<Leader>gcn", "<cmd>GitConflictNextConflict<CR>", desc = "move to next conflict" },
			{ "<Leader>gcc", "<cmd>GitConflictChooseOurs<CR>", desc = "choose current" },
			{ "<Leader>gcp", "<cmd>GitConflictPrevConflict<CR>", desc = "move to prev conflict" },
			{ "<Leader>gci", "<cmd>GitConflictChooseTheirs<CR>", desc = "choose incoming" },
		},
	},

	-----------------------------------------------------------------------------
	-- Git UI
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
    --stylua: ignore start
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'Lazygit'  },
    },
	},
	{
		"sindrets/diffview.nvim",
		event = "BufRead",
		keys = {
			{ "<Leader>gd", "<cmd>DiffviewFileHistory %<CR>", desc = "Diff File" },
			{ "<Leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Diff View" },
		},
		config = function()
			require("diffview").setup({
				keymaps = {
					view = {
						["j"] = false,
						["k"] = false,
						["l"] = false,
						["h"] = false,
					},
					file_panel = {
						["j"] = false,
						["k"] = false,
						["l"] = false,
						["h"] = false,
					},
					file_history_panel = {
						["j"] = false,
						["k"] = false,
						["l"] = false,
						["h"] = false,
					},
				},
			})
		end,
	},

	-----------------------------------------------------------------------------
	-- Leetcode Problems
	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html",
		cmd = "Leet",
		dependencies = {
			-- 'nvim-telescope/telescope.nvim',
			"nvim-lua/plenary.nvim", -- required by telescope
			"MunifTanjim/nui.nvim",

			-- optional
			"nvim-treesitter/nvim-treesitter",
			"rcarriga/nvim-notify",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			-- configuration goes here
			lang = "python3",
		},
	},
	{
		"roobert/f-string-toggle.nvim",
		config = function()
			require("f-string-toggle").setup({
				key_binding = "<leader>f",
				key_binding_desc = "Toggle f-string",
			})
		end,
	},

	-----------------------------------------------------------------------------
	-- Lsp Saga
	{
		"nvimdev/lspsaga.nvim",
		event = { "LspAttach" },
		opts = {
			lightbulb = {
				enable = false,
				enable_in_insert = false,
				sign = false,
				sign_priority = 40,
				virtual_text = false,
			},
			finder = {
				max_height = 0.5,
				min_width = 30,
				force_max_height = false,
				keys = {
					jump_to = "p",
					expand_or_jump = "o",
					vsplit = "s",
					split = "i",
					tabe = "t",
					quit = { "q", "<ESC>" },
				},
			},
			definition = {
				edit = "<C-c>o",
				vsplit = "<C-c>v",
				split = "<C-c>i",
				tabe = "<C-c>t",
				quit = "q",
			},
			code_action = {
				num_shortcut = true,
				keys = {
					quit = "q",
					exec = "<CR>",
				},
			},
		},
		config = function(_, opts)
			require("lspsaga").setup(opts)
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},

	{
		"ThePrimeagen/refactoring.nvim",
		keys = {
			{
				"<leader>r",
				function()
					require("refactoring").select_refactor()
				end,
				mode = "v",
				noremap = true,
				silent = true,
				expr = false,
			},
		},
		opts = {},
	},

	{
		"folke/todo-comments.nvim",
		event = "BufReadPost",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = true,
			sign_priority = 8,
			keywords = {
				FIX = {
					alt = { "FIX", "BUG", "ISSUE" },
				},
				WARN = { alt = { "WARNING" } },
				PERF = { alt = { "OPT", "OPTIMIZE" } },
			},
			highlight = {
				before = "",
				keyword = "wide",
				after = "fg",
				pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
				comments_only = true,
				max_line_len = 400,
				exclude = {},
			},
		},
	},

	-----------------------------------------------------------------------------
	-- LSP Diagnostics and quickfix
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {},

		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<CR>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
				desc = "buffer Disagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<CR>",
				desc = "Symbols (Trouble)",
			},
			-- {
			--   '<leader>cl',
			--   '<cmd>Trouble lsp toggle focus=false win.position=right<CR>',
			--   desc = 'LSP Definitions / references / ... (Trouble)',
			-- },
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<CR>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle <cr>",
				desc = "Quickfix list (Trouble)",
			},
		},
	},

	{
		"2kabhishek/exercism.nvim",
		cmd = {
			"ExercismLanguages",
			"ExercismList",
			"ExercismSubmit",
			"ExercismTest",
		},
		keys = {
			{ "<leader>lxa", "<cmd>ExercismList<CR>", desc = "Exercism All exercises" },
			{ "<leader>lxl", "<cmd>ExercismLanguages<CR>", desc = "Exercism Languages" },
			{ "<leader>lxt", "<cmd>ExercismTest<CR>", desc = "ExercismTest" },
			{ "<leader>lxs", "<cmd>ExercismSubmit<CR>", desc = "ExercismSubmit" },
		},
		dependencies = {
			{
				"2kabhishek/utils.nvim",
				opts = {
					fuzzy_provider = "snacks",
				},
			},
			"2kabhishek/termim.nvim", -- optional, better UX for running tests
		},
		-- Add your custom configs here, keep it blank for default configs (required)
		opts = {
			exercism_workspace = "~/exercism",
			default_language = "typescript",
			add_default_keybindings = false,
		},
		config = function(_, opts)
			require("exercism").setup(opts)
		end,
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup()
			vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
		end,
	},
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		enabled = false,
		opts = {
			modes = { insert = true, command = true, terminal = false },
			-- skip autopair when next character is one of these
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			-- skip autopair when the cursor is inside these treesitter nodes
			skip_ts = { "string" },
			-- skip autopair when next character is closing pair
			-- and there are more closing pairs than opening pairs
			skip_unbalanced = true,
			-- better deal with markdown code blocks
			markdown = true,
		},
		config = function(_, opts)
			LazyVim.mini.pairs(opts)
		end,
	},
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({ -- code block
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
					d = { "%f[%d]%d+" }, -- digits
					e = { -- Word with case
						{
							"%u[%l%d]+%f[^%l%d]",
							"%f[%S][%l%d]+%f[^%l%d]",
							"%f[%P][%l%d]+%f[^%l%d]",
							"^[%l%d]+%f[^%l%d]",
						},
						"^().*()$",
					},
					g = LazyVim.mini.ai_buffer, -- buffer
					u = ai.gen_spec.function_call(), -- u for "Usage"
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)
			vim.schedule(function()
				LazyVim.mini.ai_whichkey(opts)
			end)
		end,
	},
}
