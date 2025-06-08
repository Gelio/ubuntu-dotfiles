local M = {}

local function setup_lsp_keymaps(_client, bufnr)
	local function signature_help()
		vim.lsp.buf.signature_help({
			border = "single",
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
		{ "g<leader>c", group = "Call hierarchy" },
		{ "g<leader>ci", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", desc = "Go to incoming calls" },
		{ "g<leader>co", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", desc = "Go to outgoing calls" },
		{ "g<leader>t", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "Go to type definition" },

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
	if not client:supports_method("textDocument/documentHighlight") then
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
	setup_lsp_keymaps(client, bufnr)
	setup_document_highlight(client)
end

-- https://cmp.saghen.dev/installation.html
local ok, cmp_capabilities = pcall(function()
	return require("blink.cmp").get_lsp_capabilities()
end)
if ok then
	M.capabilities = cmp_capabilities
end

-- https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
M.capabilities = vim.tbl_deep_extend("force", M.capabilities or {}, {
	textDocument = {
		foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		},
	},
})

-- Base config for LSP's setup method
M.base_config = {
	on_attach = M.on_attach,
	capabilities = M.capabilities,
}

return M
