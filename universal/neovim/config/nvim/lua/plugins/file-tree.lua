return {
	{
		"stevearc/oil.nvim",
		opts = function()
			-- selene: allow(global_usage)
			function _G.oil_winbar()
				local current_dir = require("oil").get_current_dir()
				local head = vim.fn.fnamemodify(current_dir, ":~:h:h")
				local tail = vim.fn.fnamemodify(current_dir, ":h:t")
				return head .. "/%#StatusLine#" .. tail .. "/"
			end

			return {
				columns = {
					"icon",
				},
				keymaps = {
					["<C-v>"] = "actions.select_vsplit",
					["<C-x>"] = "actions.select_split",
					["<C-s>"] = "actions.select_split",
				},
				win_options = {
					winbar = "%{%v:lua.oil_winbar()%}",
					-- NOTE: needed for oil-git-status.nvim icons
					signcolumn = "yes:2",
				},
			}
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
		},
		-- Load the plugin eagerly so oil takes over netrw when `nvim .`
		lazy = false,
	},
	{
		"refractalize/oil-git-status.nvim",
		dependencies = {
			"stevearc/oil.nvim",
		},
		ft = "oil",
		config = true,
	},
}
