local utils = require("lsp.utils")
local lsp_installer = require("nvim-lsp-installer")

lsp_installer.setup({})

local default_server_config = utils.base_config

---Configs for known LSP servers.
---Presence of a server in this table means it will get installed
---by `:InstallDefaultLspServers`
local server_configs = {
	-- Use null_ls for formatting
	gopls = utils.base_config_without_formatting,
	jsonls = require("lsp.jsonls").config,
	-- Conflicts with prettier formatting in TS files.
	stylelint_lsp = utils.base_config_without_formatting,
	sumneko_lua = require("lsp.lua").config,
	tsserver = require("lsp.tsserver").config,
	texlab = require("lsp.tex").config,
	rust_analyzer = default_server_config,
	bashls = default_server_config,
	cssls = default_server_config,
	svelte = default_server_config,
	eslint = default_server_config,
	yamlls = default_server_config,
	vimls = default_server_config,
}

local lspconfig = require("lspconfig")
local function setup_lsp_servers()
	for server_name, server_config in pairs(server_configs) do
		lspconfig[server_name].setup(server_config)
	end
end

setup_lsp_servers()

vim.api.nvim_create_user_command("InstallDefaultLspServers", function()
	for server_name in pairs(server_configs) do
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
