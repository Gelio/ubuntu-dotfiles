return {
	{
		"tpope/vim-dispatch",
		init = function()
			-- NOTE: disable default keymaps
			vim.g.dispatch_no_maps = 1
		end,
		cmd = {
			"Make",
			"Dispatch",
			"Copen",
			"FocusDispatch",
			"Focus",
		},
	},
}
