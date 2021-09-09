local M = {}

local function setup_lsp_ts_utils(client)
	local ts_utils = require("nvim-lsp-ts-utils")
	ts_utils.setup({
		eslint_bin = "eslint_d",
		eslint_enable_diagnostics = true,
		eslint_diagnostics_debounce = 500,

		-- TODO: possibly remove it, as I set up null-ls myself
		enable_formatting = true,
		formatter = "prettierd",
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
