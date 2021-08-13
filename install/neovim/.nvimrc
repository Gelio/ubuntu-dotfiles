lua << EOF
  local my_config = require('lsp')

  local function getcwd()
    return vim.fn.getcwd()
  end
  require('lspconfig')['null-ls'].setup({
    root_dir = getcwd,
    on_attach = my_config.on_attach,
  })
EOF
