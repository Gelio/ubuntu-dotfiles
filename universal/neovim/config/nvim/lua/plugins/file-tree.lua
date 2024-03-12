return {
	{
		"stevearc/oil.nvim",
		opts = {
			columns = {
				"icon",
			},
			keymaps = {
				["<C-v>"] = "actions.select_vsplit",
				["<C-x>"] = "actions.select_split",
			},
			win_options = {
				winbar = "%{v:lua.require('oil').get_current_dir()}",
			},
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
		},
		-- Load the plugin eagerly so oil takes over netrw when `nvim .`
		lazy = false,
	},
}
