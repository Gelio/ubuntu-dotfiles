return {
	{
		"tpope/vim-dispatch",
		dependencies = {
			{
				"radenling/vim-dispatch-neovim",
			},
		},
		init = function()
			-- NOTE: disable default keymaps
			vim.g.dispatch_no_maps = 1
		end,
		config = function()
			local dispatch_handlers = vim.g.dispatch_handlers
			table.insert(dispatch_handlers, 1, "neovim")
			-- NOTE: using table.insert on a vim.g variable directly does not modify it,
			-- since vim.g.dispatch_handlers returns a copy.
			vim.g.dispatch_handlers = dispatch_handlers
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
