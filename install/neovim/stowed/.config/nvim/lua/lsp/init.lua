local utils = require("lsp.utils")
local nvim_lsp = require("lspconfig")

local servers_with_defaults = { "gopls", "rust_analyzer", "bashls", "cssls", "svelte", "eslint", "yamlls", "vimls" }
for _, lsp in ipairs(servers_with_defaults) do
	nvim_lsp[lsp].setup(utils.base_config)
end

-- Conflicts with prettier formatting in TS files.
nvim_lsp.stylelint_lsp.setup(utils.base_config_without_formatting)

-- Use null_ls for formatting
nvim_lsp.gopls.setup(utils.base_config_without_formatting)

nvim_lsp.jsonls.setup(require("lsp.jsonls").config)

nvim_lsp.graphql.setup(require("lsp.graphql").config)

nvim_lsp.tsserver.setup(require("lsp.tsserver").config)

nvim_lsp.sumneko_lua.setup(require("lsp.lua").config)

nvim_lsp.texlab.setup(require("lsp.tex").config)

require("lsp.java").setup()
require("lsp.null-ls").setup()

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = {
		source = "always",
	},
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

require("auto-nvimrc").execute_nvimrcs()
