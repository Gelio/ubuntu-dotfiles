local M = {}

local function setup_lsp_keymaps(bufnr)
	local wk = require("which-key")
	wk.register({
		g = {
			D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to declaration" },
			d = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition" },
			i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation" },
			r = { "<cmd>lua vim.lsp.buf.references()<CR>", "Go to references" },
		},
		["<C-W>gd"] = {
			-- TODO: try to use "gd" map with noremap = false
			"<cmd>tab split | lua vim.lsp.buf.definition()<CR>",
			"Go to definition in a new tab",
			-- noremap = false
		},
		["<Leader>"] = {
			D = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Go to type definition" },
			rn = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
			e = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "Show diagnostics for current line" },
			ac = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code actions" },
			q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", "Show diagnostics in quickfix list" },
			-- TODO: fix range actions, add them in visual mode
			ar = { "<cmd>lua vim.lsp.buf.range_code_action()<CR>", "Range code actions", mode = "v" },
		},
		K = { "<Cmd>lua vim.lsp.buf.hover()<CR>", "Show hover popup" },
		["<C-k>"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Show signature kelp" },
		["[d"] = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", "Go to previous diagnostic" },
		["]d"] = { "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", "Go to next diagnostic" },
	}, {
		buffer = bufnr,
	})
end

local function setup_formatting(client, bufnr)
	local wk = require("which-key")

	if client.resolved_capabilities.document_formatting then
		wk.register({
			["<Leader>F"] = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format" },
		}, { buffer = bufnr })
		vim.cmd([[
      augroup SyncFormatting
        autocmd! BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
      augroup END
    ]])
	end

	if client.resolved_capabilities.document_range_formatting then
		wk.register({
			["<Leader>F"] = { "<cmd>lua vim.lsp.buf.range_formatting()<CR>", "Format range" },
		}, {
			mode = "v",
			buffer = bufnr,
		})
	end
end

local function setup_document_highlight(client)
	if not client.resolved_capabilities.document_highlight then
		return
	end

	vim.cmd(
		-- TODO: check if the guibg are still needed
		[[
      hi LspReferenceText  cterm=bold ctermbg=red guibg=#404040
      hi LspReferenceRead  cterm=bold ctermbg=red guibg=#404040
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#404040
      augroup LSPDocumentHighlight
        autocmd! * <buffer>
        autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
		false
	)
end

function M.on_attach(client, bufnr)
	vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

	setup_lsp_keymaps(bufnr)
	setup_formatting(client, bufnr)
	setup_document_highlight(client)

	require("lsp_signature").on_attach({
		zindex = 50, -- signature should appear below nvim-cmp completions
	})
end

-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#show-source-in-diagnostics-neovim-05106-only
function M.publish_diagnostics_handler(_, params, ctx, config)
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

-- See https://github.com/hrsh7th/cmp-nvim-lsp
-- Takes care of autocomplete support using snippets for some LSP servers (cssls, jsonls)
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = require("cmp_nvim_lsp").update_capabilities(M.capabilities)

-- Return a function that runs functions passed in the argument.
-- They will be called in the same order that they were passed in.
-- Useful for composing multiple `on_attach` functions.
---@diagnostic disable-next-line: unused-vararg
function M.run_all(...)
	local fns = { ... }

	return function(...)
		for _, fn in ipairs(fns) do
			fn(...)
		end
	end
end

-- Disables formatting for an LSP client
-- Useful when multiple clients are capable of formatting
-- but we want to enable only one of them.
function M.disable_formatting(client)
	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false
end

-- Base config for LSP's setup method
M.base_config = {
	on_attach = M.on_attach,
	capabilities = M.capabilities,
}

-- Base config for LSP's setup method that disables client's formatting
-- Useful when there is another client that is responsible for formatting.
M.base_config_without_formatting = vim.tbl_extend("force", M.base_config, {
	on_attach = M.run_all(M.disable_formatting, M.on_attach),
})

return M