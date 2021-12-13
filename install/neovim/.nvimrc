lua << EOF
  local nvimrc_dir = vim.fn.expand("<sfile>:p:h")
  local config = vim.tbl_extend('error', require('lsp.null-ls').config, {
    root_dir = function() return nvimrc_dir end,
  })

  local null_ls = require('null-ls')
  null_ls.deregister({ name = "selene"})
  null_ls.register(null_ls.builtins.diagnostics.selene.with({
    name = "selene",
    cwd = function() return nvimrc_dir end,
  }))


EOF
