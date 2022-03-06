local M = {}

local lsp_ts_utils = require("nvim-lsp-ts-utils")

local function setup_lsp_ts_utils(client)
	lsp_ts_utils.setup({
		auto_inlay_hints = false,
	})
	lsp_ts_utils.setup_client(client)
end

local utils = require("lsp.utils")

-- Disable tsserver formatting, use prettierd from null-ls inside ts-utils
-- See https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils#setup
M.on_attach = utils.run_all(utils.disable_formatting, setup_lsp_ts_utils, utils.on_attach)

-- Overwrite on_attach, but error if init_options would be overwritten
M.config = vim.tbl_extend(
	"error",
	vim.tbl_extend("force", utils.base_config, {
		on_attach = M.on_attach,
	}),
	{ init_options = lsp_ts_utils.init_options }
)

return M
