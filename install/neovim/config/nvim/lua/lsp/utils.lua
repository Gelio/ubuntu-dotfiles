local M = {}

local function if_enabled(condition, mapping)
	return condition and mapping or nil
end

local function setup_lsp_keymaps(client, bufnr)
	local wk = require("which-key")

	local function if_supports(method, mapping)
		return if_enabled(client.supports_method(method), mapping)
	end

	wk.register({
		g = {
			D = if_supports("textDocument/declaration", { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to declaration" }),
			d = if_supports("textDocument/definition", { "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition" }),
			i = if_supports(
				"textDocument/implementation",
				{ "<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation" }
			),
			r = if_supports("textDocument/references", { "<cmd>lua vim.lsp.buf.references()<CR>", "Go to references" }),
			["<Leader>c"] = {
				name = "Call hierarchy",
				i = if_supports(
					"callHierarchy/incomingCalls",
					{ "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", "Go to incoming calls" }
				),
				o = if_supports(
					"callHierarchy/outgoingCalls",
					{ "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", "Go to outgoing calls" }
				),
			},
			["<Leader>t"] = if_supports(
				"textDocument/typeDefinition",
				{ "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Go to type definition" }
			),
		},
		["<C-W>gd"] = if_supports("textDocument/definition", {
			"<cmd>tab split | norm gd<CR>",
			"Go to definition in a new tab",
		}),
		["<Leader>"] = {
			rn = if_supports("textDocument/rename", { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" }),
			d = {
				function()
					vim.diagnostic.open_float({
						scope = "line",
						source = true,
					})
				end,
				"Show diagnostics for current line",
			},
			ac = if_supports("codeAction/resolve", { "<cmd>CodeActionMenu<CR>", "Code actions", mode = { "v", "n" } }),
			q = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Show diagnostics in location list" },
		},
		K = if_supports("textDocument/hover", { "<Cmd>lua vim.lsp.buf.hover()<CR>", "Show hover popup" }),
		["<C-k>"] = if_supports(
			"textDocument/signatureHelp",
			{ "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Show signature kelp" }
		),
		["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Go to previous diagnostic" },
		["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Go to next diagnostic" },
	}, {
		buffer = bufnr,
	})
end

local sync_formatting_augroup = vim.api.nvim_create_augroup("SyncFormatting", {})

local function setup_formatting(client, bufnr)
	local wk = require("which-key")

	if client.supports_method("textDocument/formatting") then
		wk.register({
			["<Leader>F"] = {
				function()
					vim.lsp.buf.format({ async = true })
				end,
				"Format",
			},
		}, {
			buffer = bufnr,
		})
		vim.api.nvim_create_autocmd("BufWritePre", {
			desc = "Format files on save",
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
			pattern = "<buffer>",
			group = sync_formatting_augroup,
		})
	end

	if client.supports_method("textDocument/rangeFormatting") then
		wk.register({
			["<Leader>F"] = {
				function()
					vim.lsp.buf.format({ async = true })
				end,
				"Format range",
			},
		}, {
			mode = "v",
			buffer = bufnr,
		})
	end
end

local function setup_document_highlight(client)
	if not client.supports_method("textDocument/documentHighlight") then
		return
	end

	vim.cmd([[
    hi LspReferenceText  cterm=bold ctermbg=red guibg=#404040
    hi LspReferenceRead  cterm=bold ctermbg=red guibg=#404040
    hi LspReferenceWrite cterm=bold ctermbg=red guibg=#404040
    augroup LSPDocumentHighlight
      autocmd! * <buffer>
      autocmd CursorHold,CursorHoldI  <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
  ]])
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
local ok, cmp_capabilities = pcall(function()
	return require("cmp_nvim_lsp").default_capabilities()
end)
if ok then
	M.capabilities = cmp_capabilities
else
	M.capabilities = vim.lsp.protocol.make_client_capabilities()
end

-- https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
M.capabilities = vim.tbl_deep_extend("force", M.capabilities, {
	textDocument = {
		foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		},
	},
})

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
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false
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
