return {
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		config = function()
			vim.o.termguicolors = true
			vim.o.cursorline = true
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
			vim.g.gruvbox_material_diagnostic_text_highlight = 1
			vim.g.gruvbox_material_diagnostic_line_highlight = 1
			vim.g.gruvbox_material_ui_contrast = "high"
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
}
