local nvim_lsp = require("lspconfig")

-- TODO: split to multiple files

local function setup_formatting(bufnr)
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

	vim.cmd([[
    augroup SyncFormatting
      autocmd! BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
    augroup END
  ]])
end

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { noremap = true, silent = true }
	buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "<C-W>gd", "<Cmd>tab split | lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
	buf_set_keymap("n", "<leader>ac", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	buf_set_keymap("n", "<leader>ar", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
	buf_set_keymap("v", "<leader>ar", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)

	if client.resolved_capabilities.document_formatting then
		setup_formatting(bufnr)
	end
	if client.resolved_capabilities.document_range_formatting then
		buf_set_keymap("v", "<leader>F", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	end

	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#404040
      hi LspReferenceText cterm=bold ctermbg=red guibg=#404040
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#404040
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
			false
		)
	end

	require("lsp_signature").on_attach({
		zindex = 50, -- signature should appear below compe completions
	})
end

local servers_with_defaults = { "gopls", "rust_analyzer", "bashls", "cssls", "svelte" }
for _, lsp in ipairs(servers_with_defaults) do
	nvim_lsp[lsp].setup({ on_attach = on_attach })
end

nvim_lsp.stylelint_lsp.setup({
	on_attach = function(client)
		-- Conflicts with prettier formatting in TS files.
		client.resolved_capabilities.document_formatting = false
	end,
})

nvim_lsp.gopls.setup({
	on_attach = function(client, buffer)
		-- Use null_ls for formatting
		client.resolved_capabilities.document_formatting = false
		on_attach(client, buffer)
	end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.jsonls.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		-- Conflicts with prettier formatting in JSON files.
		client.resolved_capabilities.document_formatting = false
		on_attach(client, bufnr)
	end,
	get_language_id = function(_, filetype)
		if filetype == "json" then
			-- NOTE: allows comments in JSON files
			return "jsonc"
		end
		return filetype
	end,
	settings = {
		json = {
			schemas = {
				-- Sources
				-- 1. VSCode
				--    https://github.com/microsoft/vscode/blob/6e5ffbde32cb783be15ddd383028c4a56a667edd/extensions/typescript-language-features/package.json#L70
				--    Use http://mageddo.com/tools/json-to-lua-converter
				--
				-- 2. SchemaStore
				--    https://www.schemastore.org/json/
				{
					fileMatch = { "package.json" },
					url = "https://json.schemastore.org/package",
				},
				{
					fileMatch = { "tsconfig.json", "tsconfig-*.json", "tsconfig.*.json" },
					url = "https://json.schemastore.org/tsconfig",
				},
				{
					fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
					url = "https://json.schemastore.org/babelrc",
				},
				{
					fileMatch = { "jsconfig.json", "jsconfig.*.json" },
					url = "https://json.schemastore.org/jsconfig",
				},
				{
					fileMatch = { ".prettierrc", ".prettierrc.json" },
					url = "https://json.schemastore.org/prettierrc.json",
				},
				{
					fileMatch = { "cypress.json" },
					url = "https://raw.githubusercontent.com/cypress-io/cypress/develop/cli/schema/cypress.schema.json",
				},
			},
		},
	},
})

nvim_lsp.graphql.setup({
	root_dir = nvim_lsp.util.root_pattern(".graphqlrc*", ".git"),
	filetypes = { "graphql", "typescript", "typescriptreact" },
	on_attach = on_attach,
})

local null_ls = require("null-ls")

local prettierd_filetypes = { unpack(null_ls.builtins.formatting.prettierd.filetypes) }
table.insert(prettierd_filetypes, "graphql")
table.insert(prettierd_filetypes, "jsonc")

local null_ls_sources = {
	null_ls.builtins.formatting.prettierd.with({
		filetypes = prettierd_filetypes,
	}),
	null_ls.builtins.formatting.trim_whitespace.with({
		filetypes = { "plantuml" },
	}),
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.diagnostics.selene,
	null_ls.builtins.diagnostics.shellcheck,
	null_ls.builtins.formatting.shfmt,
	null_ls.builtins.diagnostics.hadolint,
	null_ls.builtins.diagnostics.markdownlint,
	null_ls.builtins.diagnostics.write_good,
	null_ls.builtins.diagnostics.misspell,
	null_ls.builtins.formatting.gofumpt,
}
null_ls.config({
	sources = null_ls_sources,
})
nvim_lsp["null-ls"].setup({
	on_attach = on_attach,
})

local function attach_tsserver(client, bufnr)
	-- Disable tsserver formatting, use prettierd from null-ls inside ts-utils
	client.resolved_capabilities.document_formatting = false
	on_attach(client, bufnr)

	local ts_utils = require("nvim-lsp-ts-utils")
	ts_utils.setup({
		eslint_bin = "eslint_d",
		eslint_enable_diagnostics = true,
		eslint_diagnostics_debounce = 500,

		enable_formatting = true,
		formatter = "prettierd",
	})
	ts_utils.setup_client(client)
end

nvim_lsp.tsserver.setup({
	on_attach = attach_tsserver,
})

-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#show-source-in-diagnostics-neovim-05106-only
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, params, ctx, config)
	local uri = params.uri
	local client_id = ctx.client_id
	local bufnr = vim.uri_to_bufnr(uri)

	if not bufnr then
		return
	end

	local diagnostics = params.diagnostics

	vim.lsp.diagnostic.save(diagnostics, bufnr, client_id)

	if not vim.api.nvim_buf_is_loaded(bufnr) then
		return
	end

	-- don't mutate the original diagnostic because it would interfere with
	-- code action (and probably other stuff, too)
	local prefixed_diagnostics = vim.deepcopy(diagnostics)
	for i, v in pairs(diagnostics) do
		prefixed_diagnostics[i].message = string.format("%s: %s", v.source, v.message)
	end
	vim.lsp.diagnostic.display(prefixed_diagnostics, bufnr, client_id, config)
end

my_config = {
	attach_tsserver = attach_tsserver,
	on_attach = on_attach,
}
require("lsp/lua")
return my_config