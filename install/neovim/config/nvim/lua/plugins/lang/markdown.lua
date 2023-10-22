return {
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npx --yes yarn install",
		ft = "markdown",
		config = function()
			vim.g.mkdp_echo_preview_url = true
		end,
	},

	{
		"AckslD/nvim-FeMaco.lua",
		cmd = { "FeMaco" },
		opts = {
			ft_from_lang = function(lang)
				if lang == "dataviewjs" then
					return "javascript"
				end

				return lang
			end,

			create_tmp_filepath = function(filetype)
				local extension = ""
				if filetype == "javascript" then
					extension = ".js"
				end

				return os.tmpname() .. extension
			end,

			ensure_newline = function(_base_filetype)
				return true
			end,
		},
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
