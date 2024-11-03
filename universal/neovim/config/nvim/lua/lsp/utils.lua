local M = {}

local function setup_lsp_keymaps(_client, bufnr)
	local function signature_help()
		vim.lsp.buf.signature_help({
			border = "single",
			zindex = M.zindex.lsp_signature,
		})
	end

	local function hover()
		vim.lsp.buf.hover({
			border = "single",
		})
	end

	require("which-key").add(vim.tbl_map(function(mapping)
		return vim.tbl_extend("force", mapping, { buffer = bufnr })
	end, {
		{ "K", hover, desc = "Hover" },
		{ "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Go to declaration" },
		{ "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Go to definition" },
		{ "gri", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Go to implementation" },
		{ "grr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "Go to references" },
		{ "g<Leader>c", group = "Call hierarchy" },
		{ "g<Leader>ci", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", desc = "Go to incoming calls" },
		{ "g<Leader>co", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", desc = "Go to outgoing calls" },
		{ "g<Leader>t", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "Go to type definition" },

		{ "<C-W>gd", "<cmd>tab split | norm gd<CR>", desc = "Go to definition in a new tab" },

		{ "grn", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename" },
		{
			"<Leader>d",
			function()
				vim.diagnostic.open_float()
			end,
			desc = "Show diagnostics for current line",
		},
		{ "gra", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code actions", mode = { "v", "n" } },
		{ "<Leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", desc = "Show diagnostics in location list" },

		{ "<C-k>", signature_help, desc = "Show signature help" },
		{ "<C-j>", signature_help, desc = "Show signature help", mode = "i" },
	}))
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
	setup_document_highlight(client)
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

--- https://github.com/hrsh7th/nvim-cmp/blob/fc0f694af1a742ada77e5b1c91ff405c746f4a26/lua/cmp/view/custom_entries_view.lua#L207
local completions_menu_zindex = 1001
M.zindex = {
	completions_menu = completions_menu_zindex,
	--- https://github.com/hrsh7th/nvim-cmp/blob/fc0f694af1a742ada77e5b1c91ff405c746f4a26/lua/cmp/view/docs_view.lua#L104
	completion_documentation = 50,
	lsp_signature = completions_menu_zindex + 1,
}

return M
