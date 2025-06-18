return {
	{
		"rebelot/kanagawa.nvim",
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
}
