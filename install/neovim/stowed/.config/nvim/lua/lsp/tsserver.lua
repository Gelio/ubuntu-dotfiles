local M = {}

local utils = require("lsp.utils")

-- Disable tsserver formatting, use prettierd from null-ls
M.on_attach = utils.run_all(utils.disable_formatting, utils.on_attach)

M.config = vim.tbl_extend("force", utils.base_config, {
	on_attach = M.on_attach,
})

return M
