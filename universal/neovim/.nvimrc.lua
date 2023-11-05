local nvimrc_dir = vim.fn.expand("<sfile>:p:h") --[[@as string]]

local lua_ls_config = require("lsp.lua").config
require("lspconfig").lua_ls.setup(vim.tbl_extend("error", lua_ls_config, {
	root_dir = function()
		return vim.fs.joinpath(nvimrc_dir, "config", "nvim")
	end,
}))
