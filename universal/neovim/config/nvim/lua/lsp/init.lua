local utils = require("lsp.utils")

local default_server_config = utils.base_config

---Configs for known LSP servers.
local server_configs = {
	-- Use gofumpt for formatting
	gopls = utils.base_config_without_formatting,
	jsonls = require("lsp.jsonls").config,
	-- Conflicts with prettier formatting in TS files.
	stylelint_lsp = vim.tbl_extend("error", utils.base_config_without_formatting, { autostart = false }),
	lua_ls = require("lsp.lua").config,
	texlab = require("lsp.tex").config,
	rust_analyzer = default_server_config,
	bashls = default_server_config,
	cssls = default_server_config,
	svelte = default_server_config,
	eslint = default_server_config,
	yamlls = default_server_config,
	vimls = default_server_config,
	marksman = default_server_config,
	terraformls = default_server_config,
	tflint = default_server_config,
	ansiblels = default_server_config,
	clangd = vim.tbl_extend("force", default_server_config, {
		filetypes = { "c", "cpp" },
	}),
	taplo = default_server_config,
	prismals = default_server_config,
	css_variables = default_server_config,
	-- https://github.com/coder3101/protols
	protols = default_server_config,
	vue_ls = default_server_config,
}

require("mason-lspconfig").setup({
	ensure_installed = vim.tbl_keys(server_configs),
})

---@param top_level_table table<string, unknown>
---@return string[]
local function get_all_values_deep(top_level_table)
	---@type table<string, boolean>
	local values = {}

	---@param tbl table<string, unknown>
	local function walk_table(tbl)
		for _, value_or_tbl in pairs(tbl) do
			if type(value_or_tbl) == "table" then
				walk_table(value_or_tbl)
			else
				values[value_or_tbl] = true
			end
		end
	end

	walk_table(top_level_table)

	return vim.tbl_keys(values)
end

local function get_linters_to_install()
	return get_all_values_deep(require("lsp.nvim-lint").linters_by_ft)
end

local function get_formatters_to_install()
	return get_all_values_deep(require("lsp.conform-nvim").formatters_by_ft)
end

require("mason-tool-installer").setup({
	ensure_installed = vim.tbl_filter(function(tool_name)
		return require("mason-registry").has_package(tool_name)
	end, vim.list_extend(get_formatters_to_install(), get_linters_to_install())),
})

local lspconfig = require("lspconfig")
local function setup_lsp_servers()
	for server_name, server_config in pairs(server_configs) do
		lspconfig[server_name].setup(server_config)
	end
end

setup_lsp_servers()

vim.diagnostic.config({
	float = {
		scope = "line",
		source = true,
		border = "single",
	},
	jump = {
		wrap = false,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
})

require("auto-nvimrc").execute_nvimrcs()
