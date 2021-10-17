local M = {}

local function setup_lsp_ts_utils(client)
	local ts_utils = require("nvim-lsp-ts-utils")
	ts_utils.setup({
		-- ESLint integration provided by ESLint language server
		eslint_enable_code_actions = false,
		eslint_enable_diagnostics = false,
	})
	ts_utils.setup_client(client)
end

local utils = require("lsp.utils")

-- Disable tsserver formatting, use prettierd from null-ls inside ts-utils
-- See https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils#setup
M.on_attach = utils.run_all(utils.disable_formatting, setup_lsp_ts_utils, utils.on_attach)

M.config = vim.tbl_extend("force", utils.base_config, {
	on_attach = M.on_attach,
})

return M
