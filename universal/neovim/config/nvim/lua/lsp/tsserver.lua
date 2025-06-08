local M = {}

local utils = require("lsp.utils")

local filetypes = vim.lsp.config.ts_ls.filetypes
assert(#filetypes > 0, "ts_ls filetypes must be defined")
-- NOTE: include vue
table.insert(filetypes, "vue")

M.config = vim.tbl_extend("force", utils.base_config, {
	filetypes = filetypes,

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
