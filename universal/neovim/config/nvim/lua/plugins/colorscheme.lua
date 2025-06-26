local colorscheme_priority = 1000

return {
	{
		"sainnhe/gruvbox-material",
		enabled = false,
		priority = colorscheme_priority,
		config = function()
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
			vim.g.gruvbox_material_diagnostic_text_highlight = 1
			vim.g.gruvbox_material_diagnostic_line_highlight = 1
			vim.g.gruvbox_material_ui_contrast = "high"
			vim.cmd.colorscheme("gruvbox-material")
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
		"navarasu/onedark.nvim",
		priority = colorscheme_priority,
		enabled = true,
		config = function()
			require("onedark").setup({
				style = "warm",
				highlights = {
					-- NOTE: a raw hex color to be brighter than `$grey` but darker than `$light_grey`.
					--`$light_grey` is too close to `$fg`, so I cannot use it.
					LineNr = { fg = "#7D7E81" },
				},
			})

			vim.cmd.colorscheme("onedark")
		end,
	},
}
