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
		enabled = true,
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
}
