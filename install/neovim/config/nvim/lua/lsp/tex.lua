local M = {}

M.config = vim.tbl_extend("error", require("lsp.utils").base_config, {
	settings = {
		texlab = {
			build = {
				forwardSearchAfter = false,
				onSave = true,
			},
			forwardSearch = {
				-- https://github.com/latex-lsp/texlab/blob/master/docs/previewing.md#evince
				executable = "evince-synctex",
				-- NOTE: inverse search does not work. I have tried many settings.
				-- Using `evince-synctex -f <line> <pdffile> 'nvim --headless -c "VimtexInverseSearch %l %f"'`
				-- on the command line works, but it does not seem to work with texlab.
				args = { "-f", "%l", "%p", 'nvim --headless -c "VimtexInverseSearch %l %f"' },
			},
			chktex = {
				onEdit = true,
				onOpenAndSave = true,
			},
		},
	},
})

return M
