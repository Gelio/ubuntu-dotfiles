return {
	{
		"rebelot/kanagawa.nvim",
		config = function()
			require("kanagawa").setup({
				overrides = function(colors)
					return {
						LineNr = { fg = colors.theme.ui.fg_dim },
					}
				end,
			})
			vim.cmd.colorscheme("kanagawa")
		end,
	},
}
