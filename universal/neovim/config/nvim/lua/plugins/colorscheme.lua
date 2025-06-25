local colorscheme_priority = 1000

return {
	{
		"rebelot/kanagawa.nvim",
		enabled = false,
		priority = colorscheme_priority,
		config = function()
			require("kanagawa").setup({
				overrides = function(colors)
					return {
						LineNr = { fg = colors.palette.boatYellow1 },
					}
				end,
			})
			vim.cmd.colorscheme("kanagawa")
		end,
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		enabled = false,
		priority = colorscheme_priority,
		config = function()
			require("catppuccin").setup({
				highlight_overrides = {
					all = function(colors)
						return {
							LineNr = { fg = colors.overlay0 },
						}
					end,
				},
				integrations = {
					diffview = true,
					fidget = true,
					headlines = true,
					lightspeed = true,
					mason = true,
					copilot_vim = true,
					nvim_surround = true,
					lsp_trouble = true,
					which_key = true,
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},

	{
		"folke/tokyonight.nvim",
		priority = colorscheme_priority,
		config = function()
			require("tokyonight").setup({
				on_highlights = function(highlights, colors)
					highlights.LineNr = { fg = colors.dark5 }
					highlights.LineNrAbove = highlights.LineNr
					highlights.LineNrBelow = highlights.LineNr
				end,
			})

			vim.cmd.colorscheme("tokyonight")
		end,
	},
}
