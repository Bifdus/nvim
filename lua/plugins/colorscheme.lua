-- Check if Dracula Pro theme is available, otherwise use Tokyonight
return (function()
	local dracula_path = vim.fn.expand("~/dracula_pro")

	if vim.fn.isdirectory(dracula_path) == 1 then
		return {
			-- Use the local directory for Dracula Pro
			dir = dracula_path,
			dev = true,
			as = "dracula_pro",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd("syntax enable")
				vim.cmd("colorscheme dracula_pro_van_helsing")

				-- Colors for rainbow highlights
				vim.cmd([[
          highlight RainbowDelimiterRed    guifg=#FF7687 ctermfg=9,
          highlight RainbowDelimiterYellow guifg=#f2f200 ctermfg=11,
          highlight RainbowDelimiterBlue   guifg=#2CCCFF ctermfg=12,
          highlight RainbowDelimiterOrange guifg=#fcbf7a ctermfg=1,
          highlight RainbowDelimiterGreen  guifg=#00c790 ctermfg=4,
          highlight RainbowDelimiterViolet guifg=#BD93F9 ctermfg=5,
          highlight RainbowDelimiterCyan   guifg=#80FFEA ctermfg=13,
        ]])
			end,
		}
	else
		-- Fallback to tokyonight if Dracula Pro is not available
		return {
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd("syntax enable")
				vim.cmd("colorscheme tokyonight")
			end,
		}
	end
end)()
