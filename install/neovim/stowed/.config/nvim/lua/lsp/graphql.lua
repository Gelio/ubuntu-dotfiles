local M = {}

M.config = vim.tbl_extend("error", require("lsp.utils").base_config, {
	root_dir = require("lspconfig").util.root_pattern(".graphqlrc*", ".git"),
	filetypes = { "graphql", "typescript", "typescriptreact" },
})

return M
