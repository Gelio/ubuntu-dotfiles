local M = {}

local utils = require("lsp.utils")

-- Disable tsserver formatting, use prettierd from null-ls
M.on_attach = utils.run_all(utils.disable_formatting, utils.on_attach)

M.config = vim.tbl_extend("force", utils.base_config, {
	on_attach = M.on_attach,
})

M.setup = function(config)
	config = config or M.config

	-- NOTE: typescript-tools.nvim needs to be the last thing that calls
	-- lspconfig.tsserver.setup for tsserver
	require("typescript-tools").setup(config)
end

return M
