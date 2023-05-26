local M = {}

local utils = require("lsp.utils")

-- Disable tsserver formatting, use prettierd from null-ls
M.on_attach = utils.run_all(utils.disable_formatting, utils.on_attach)

M.config = vim.tbl_extend("force", utils.base_config, {
	on_attach = M.on_attach,
})

M.setup = function(config)
	if config == nil then
		config = M.config
	end

	-- NOTE: typescript.nvim needs to be the last thing that calls
	-- lspconfig.tsserver.setup for tsserver
	require("typescript").setup({
		server = config,
	})
end

return M
