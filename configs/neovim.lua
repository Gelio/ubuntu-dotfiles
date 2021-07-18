local nvim_lsp = require('lspconfig')

local function setup_formatting(bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  vim.cmd([[
    augroup SyncFormatting
      autocmd! * <buffer>
      autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
    augroup END
  ]])
end

local function setup_async_formatting(bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  -- Use asynchronous formatting from null-ls
  vim.cmd([[
    augroup AsyncFormatting
      autocmd! * <buffer>
      autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()
    augroup END
  ]])
end

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<C-W>gd', '<Cmd>tab split | lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>ar', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  buf_set_keymap('v', '<leader>ar', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)

  if client.resolved_capabilities.document_formatting then
    setup_formatting(bufnr)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<leader>F", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#404040
      hi LspReferenceText cterm=bold ctermbg=red guibg=#404040
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#404040
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end

  require'lsp_signature'.on_attach()
end

local servers_with_defaults = { "gopls", "rust_analyzer", "bashls", "cssls", "svelte" }
for _, lsp in ipairs(servers_with_defaults) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end

nvim_lsp.stylelint_lsp.setup {
  on_attach = function(client, bufnr)
    -- Conflicts with prettier formatting in TS files.
    client.resolved_capabilities.document_formatting = false
  end,
}

nvim_lsp.jsonls.setup {
  on_attach = function(client, bufnr)
    -- Conflicts with prettier formatting in JSON files.
    client.resolved_capabilities.document_formatting = false
    on_attach(client, bufnr)
  end,
}

nvim_lsp.graphql.setup {
  root_dir = nvim_lsp.util.root_pattern('.graphqlrc*', '.git'),
  on_attach = on_attach,
}

local null_ls = require("null-ls")
local null_ls_sources = {
  null_ls.builtins.formatting.prettierd.with({
    filetypes = { "css", "html", "json", "yaml", "markdown", "scss", "graphql" }
  }),
}
null_ls.setup {
  sources = null_ls_sources,
}
-- Manually add formatting on save for file types that do not have their own LSPs
vim.cmd("autocmd BufWritePost *.scss,*.html,*.json,*.md,*.css,*.yml,*.yaml,*.graphql lua vim.lsp.buf.formatting()")

local function attach_tsserver(client, bufnr)
  -- Disable tsserver formatting, use prettierd from null-ls inside ts-utils
  client.resolved_capabilities.document_formatting = false
  on_attach(client, bufnr)
  setup_async_formatting(bufnr)

  local ts_utils = require("nvim-lsp-ts-utils")
  ts_utils.setup {
    eslint_bin = "eslint_d",
    eslint_enable_diagnostics = true,
    eslint_diagnostics_debounce = 500,

    enable_formatting = true,
    formatter = 'prettierd',
  }
  ts_utils.setup_client(client)
end

nvim_lsp.tsserver.setup {
  on_attach = attach_tsserver
}

require'compe'.setup {
  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = false;
    tabnine = false;
  };
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      spacing = 2,
      severity_limit = "Warning",
    },
  }
)

my_config = {
  attach_tsserver = attach_tsserver,
  on_attach = on_attach,
}
return my_config
