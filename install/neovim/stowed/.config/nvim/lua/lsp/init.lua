local utils = require("lsp.utils")
local nvim_lsp = require("lspconfig")

local servers_with_defaults = { "gopls", "rust_analyzer", "bashls", "cssls", "svelte" }
for _, lsp in ipairs(servers_with_defaults) do
	nvim_lsp[lsp].setup(utils.base_config)
end

-- Conflicts with prettier formatting in TS files.
nvim_lsp.stylelint_lsp.setup(utils.base_config_without_formatting)

-- Use null_ls for formatting
nvim_lsp.gopls.setup(utils.base_config_without_formatting)

nvim_lsp.jsonls.setup(require("lsp.jsonls").config)

nvim_lsp.graphql.setup(require("lsp.graphql").config)

local null_ls_config = require("lsp.null-ls").config
nvim_lsp["null-ls"].setup(null_ls_config)

nvim_lsp.tsserver.setup(require("lsp.tsserver").config)

nvim_lsp.sumneko_lua.setup(require("lsp.lua").config)

nvim_lsp.java_language_server.setup(require("lsp.java").config)

vim.lsp.handlers["textDocument/publishDiagnostics"] = utils.publish_diagnostics_handler

-- NOTE: Manually source .nvimrc to possibly override some configs
-- https://github.com/neovim/neovim/issues/13501#issuecomment-758604989
local local_vimrc = vim.fn.getcwd() .. "/.nvimrc"
if vim.loop.fs_stat(local_vimrc) then
	vim.cmd("source " .. local_vimrc)
end
