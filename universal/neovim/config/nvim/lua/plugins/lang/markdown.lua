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
				elseif filetype == "lua" then
					extension = ".lua"
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
			vim.g.vim_markdown_auto_insert_bullets = 0
			vim.g.vim_markdown_new_list_item_indent = 0

			local augroup = vim.api.nvim_create_augroup("VimMarkdownOverrides", {})
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				group = augroup,
				callback = function()
					-- NOTE: vim-markdown's indentexpr is annoying to work with
					vim.bo.indentexpr = ""
				end,
			})
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

	{
		"Gelio/nvim-relative-date",
		config = true,
		ft = "markdown",
		cmd = { "RelativeDateAttach", "RelativeDateToggle" },
	},
}
