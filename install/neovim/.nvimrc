lua << EOF
  local nvimrc_dir = vim.fn.expand("<sfile>:p:h")
  local config = vim.tbl_extend('error', require('lsp.null-ls').config, {
    root_dir = function() return nvimrc_dir end,
  })

  require('lspconfig')['null-ls'].setup(config)
EOF
