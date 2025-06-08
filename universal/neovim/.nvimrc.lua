---@type string
local nvimrc_dir = vim.fn.expand("<sfile>:p:h")

vim.lsp.config("lua_ls", {
	root_dir = vim.fs.joinpath(nvimrc_dir, "config", "nvim"),
})
