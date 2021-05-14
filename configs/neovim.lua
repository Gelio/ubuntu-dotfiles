local nvim_lsp = require('lspconfig')

local function setup_formatting(bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  vim.api.nvim_command("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
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

local servers_with_defaults = { "gopls", "rust_analyzer", "jsonls", "bashls", "cssls", "svelte" }
for _, lsp in ipairs(servers_with_defaults) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end

nvim_lsp.stylelint_lsp.setup {
  on_attach = function(client, bufnr)
    -- Conflicts with prettier formatting in TS files.
    client.resolved_capabilities.document_formatting = false
  end,
}

nvim_lsp.tsserver.setup {
  on_attach = function(client, bufnr)
    -- Format using prettier
    client.resolved_capabilities.document_formatting = false
    on_attach(client, bufnr)

    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.setup {
      eslint_bin = "eslint_d",
      eslint_enable_diagnostics = true,
      eslint_diagnostics_debounce = 500,

      -- Formatting done by prettier using efm, still
      enable_formatting = false,
    }
    ts_utils.setup_client(client)
  end,
}

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = false;
    tabnine = true;
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

local prettier = {
  formatStdin = true,
  formatCommand = "prettierd ${INPUT}"
}

local efm_settings = {
  javascript = {prettier},
  javascriptreact = {prettier},
  ["javascript.jsx"] = {prettier},
  typescript = {prettier},
  ["typescript.tsx"] = {prettier},
  typescriptreact = {prettier},
  markdown = {prettier},
  html = {prettier},
  css = {prettier},
  scss = {prettier},
  json = {prettier},
  yaml = {prettier},
  svelte = {prettier},
}

function get_table_keys(tab)
  local keyset = {}
  for k, v in pairs(tab) do
    keyset[#keyset + 1] = k
  end
  return keyset
end

nvim_lsp.efm.setup {
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.goto_definition = false
    setup_formatting(bufnr)
  end,
  settings = {
    languages = efm_settings,
  },
  filetypes = get_table_keys(efm_settings)
}

