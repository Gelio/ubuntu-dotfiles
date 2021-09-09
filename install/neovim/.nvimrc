lua << EOF
  local function getcwd()
    return vim.fn.getcwd()
  end

  local config = vim.tbl_extend('error', require('lsp.null-ls').config, {
    root_dir = getcwd,
  })

  require('lspconfig')['null-ls'].setup(config)
EOF
