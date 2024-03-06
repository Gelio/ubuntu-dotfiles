local augroup = vim.api.nvim_create_augroup("Customizations", {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  group = augroup,
  callback = function()
    vim.wo.wrap = true
    vim.wo.linebreak = true
  end,
})

vim.api.nvim_create_user_command("Tsc", "Dispatch -compiler=tsc NO_COLOR=1 npm run tsc", {})

local tsserver_lsp = require("lsp.tsserver")

local nvimrc_path = vim.fn.expand("<script>:h")
tsserver_lsp.setup(vim.tbl_extend("force", tsserver_lsp.config, {
  settings = {
    tsserver_file_preferences = {
      quotePreference = "single",
    },
  },
  root_dir = function()
    return nvimrc_path
  end,
}))
