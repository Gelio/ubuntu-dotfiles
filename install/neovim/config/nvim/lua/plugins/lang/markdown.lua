return {
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && yarn install",
		ft = "markdown",
		config = function()
			vim.g.mkdp_echo_preview_url = true
		end,
	},

	{
		"AckslD/nvim-FeMaco.lua",
		cmd = { "FeMaco" },
		config = function()
			require("femaco").setup()
		end,
	},

	{
		"plasticboy/vim-markdown",
		config = function()
			vim.g.vim_markdown_no_extensions_in_markdown = true
		end,
		ft = "markdown",
		dependencies = {
			"godlygeek/tabular",
		},
	},

	{
		"mzlogin/vim-markdown-toc",
		ft = "markdown",
	},
}
