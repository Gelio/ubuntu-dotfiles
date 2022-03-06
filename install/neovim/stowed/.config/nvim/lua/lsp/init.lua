local utils = require("lsp.utils")
local lsp_installer = require("nvim-lsp-installer")

local function setup_server_with_config(config)
	---@param server Server
	return function(server)
		return server:setup(config)
	end
end

---Custom handlers for known LSP servers.
---`nil` will use the default handler with the default config.
---Presence of a server in this config means it will get installed
---by `:InstallDefaultLspServers`
local server_handlers = {
	-- Use null_ls for formatting
	gopls = setup_server_with_config(utils.base_config_without_formatting),
	jsonls = setup_server_with_config(require("lsp.jsonls").config),
	-- Conflicts with prettier formatting in TS files.
	stylelint_lsp = setup_server_with_config(utils.base_config_without_formatting),
	sumneko_lua = setup_server_with_config(require("lsp.lua").config),
	tsserver = setup_server_with_config(require("lsp.tsserver").config),
	texlab = setup_server_with_config(require("lsp.tex").config),
	rust_analyzer = nil,
	bashls = nil,
	cssls = nil,
	svelte = nil,
	eslint = nil,
	yamlls = nil,
	vimls = nil,
}

lsp_installer.on_server_ready(function(server)
	local custom_handler = server_handlers[server.name]
	if custom_handler ~= nil then
		custom_handler(server)
	else
		server:setup(utils.base_config)
	end
end)

vim.api.nvim_add_user_command("InstallDefaultLspServers", function()
	for server_name in pairs(server_handlers) do
		lsp_installer.install(server_name)
	end
end, {})

require("lsp.java").setup()
require("lsp.null-ls").setup()

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = {
		source = "always",
	},
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

local function use_icons_for_diagnostic_signs()
	-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#change-diagnostic-symbols-in-the-sign-column-gutter
	local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end
end

use_icons_for_diagnostic_signs()

require("auto-nvimrc").execute_nvimrcs()
