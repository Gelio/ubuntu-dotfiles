local M = {}

local function setup_lsp_keymaps(client, bufnr)
	local function if_enabled(condition, mapping)
		return condition and mapping or nil
	end

	local wk = require("which-key")
	local capabilities = client.resolved_capabilities

	wk.register({
		g = {
			D = if_enabled(capabilities.declaration, { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to declaration" }),
			d = if_enabled(
				capabilities.goto_definition,
				{ "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition" }
			),
			i = if_enabled(
				capabilities.implementation,
				{ "<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation" }
			),
			r = if_enabled(
				capabilities.find_references,
				{ "<cmd>lua vim.lsp.buf.references()<CR>", "Go to references" }
			),
		},
		["<C-W>gd"] = if_enabled(capabilities.goto_definition, {
			"<cmd>tab split | norm gd<CR>",
			"Go to definition in a new tab",
		}),
		["<Leader>"] = {
			D = if_enabled(
				capabilities.type_definition,
				{ "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Go to type definition" }
			),
			rn = if_enabled(capabilities.rename, { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" }),
			d = {
				function()
					vim.diagnostic.open_float(0, { scope = "line" })
				end,
				"Show diagnostics for current line",
			},
			ac = if_enabled(capabilities.code_action, { "<cmd>CodeActionMenu<CR>", "Code actions" }),
			q = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Show diagnostics in location list" },
			ar = if_enabled(capabilities.code_action, { "<cmd>CodeActionMenu<CR>", "Range code actions", mode = "v" }),
		},
		K = if_enabled(capabilities.hover, { "<Cmd>lua vim.lsp.buf.hover()<CR>", "Show hover popup" }),
		["<C-k>"] = if_enabled(
			capabilities.signature_help,
			{ "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Show signature kelp" }
		),
		["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Go to previous diagnostic" },
		["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Go to next diagnostic" },
	}, {
		buffer = bufnr,
	})
end

local function setup_formatting(client, bufnr)
	local wk = require("which-key")

	if client.resolved_capabilities.document_formatting then
		wk.register({
			["<Leader>F"] = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format" },
		}, {
			buffer = bufnr,
		})
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

	setup_lsp_keymaps(client, bufnr)
	setup_formatting(client, bufnr)
	setup_document_highlight(client)

	require("lsp_signature").on_attach({
		zindex = 50, -- signature should appear below nvim-cmp completions
	})
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
