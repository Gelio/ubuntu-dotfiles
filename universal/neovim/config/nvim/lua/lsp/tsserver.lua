local M = {}

local utils = require("lsp.utils")

-- Disable tsserver formatting, use prettierd from conform.nvim
M.on_attach = utils.run_all(utils.disable_formatting, utils.on_attach)

M.config = vim.tbl_extend("force", utils.base_config, {
	on_attach = M.on_attach,

	-- NOTE: hardcode filetypes to include vue
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
	},

	settings = {
		tsserver_plugins = {
			"@vue/typescript-plugin",
		},
	},
})

M.setup = function(config)
	if config == nil then
		config = M.config
	end

	-- NOTE: typescript-tools.nvim needs to be the last thing that calls
	-- lspconfig.tsserver.setup for tsserver
	require("typescript-tools").setup(config)
end

return M
