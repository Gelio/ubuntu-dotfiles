vim.cmd.compiler({ "tsc", bang = true })
-- NOTE: hide colors in tsc output for vim-dispatch-neovim to parse errors
-- correctly
-- https://github.com/radenling/vim-dispatch-neovim/issues/16#issuecomment-645473536
vim.o.makeprg = "yarn typecheck --pretty false"

local tsserver = require("lsp.tsserver")

local src_js_directory_path = vim.fn.expand("<sfile>:h")
tsserver.setup(vim.tbl_extend("force", tsserver.config, {
	root_dir = function(_filename, _bufnr)
		return src_js_directory_path
	end,
}))
