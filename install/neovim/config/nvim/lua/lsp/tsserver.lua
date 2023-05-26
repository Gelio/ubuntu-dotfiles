local M = {}

local utils = require("lsp.utils")

-- Disable tsserver formatting, use prettierd from null-ls
M.on_attach = utils.run_all(utils.disable_formatting, utils.on_attach)

local inlay_hints_settings = {
	includeInlayParameterNameHints = "all",
	includeInlayParameterNameHintsWhenArgumentMatchesName = false,
	includeInlayFunctionParameterTypeHints = true,
	includeInlayVariableTypeHints = true,
	includeInlayVariableTypeHintsWhenTypeMatchesName = false,
	includeInlayPropertyDeclarationTypeHints = true,
	includeInlayFunctionLikeReturnTypeHints = true,
	includeInlayEnumMemberValueHints = true,
}

M.config = vim.tbl_extend("force", utils.base_config, {
	on_attach = M.on_attach,

	-- NOTE: enable inlay hints
	-- @see https://github.com/lvimuser/lsp-inlayhints.nvim#typescript
	settings = {
		typescript = {
			inlayHints = inlay_hints_settings,
		},
		javascript = {
			inlayHints = inlay_hints_settings,
		},
	},
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
