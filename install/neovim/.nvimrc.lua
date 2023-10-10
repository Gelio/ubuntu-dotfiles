local nvimrc_dir = vim.fn.expand("<sfile>:p:h")

local null_ls = require("null-ls")
null_ls.deregister({ name = "selene" })
null_ls.register(null_ls.builtins.diagnostics.selene.with({
	name = "selene",
	cwd = function()
		return nvimrc_dir
	end,
}))

local lua_ls_config = require("lsp.lua").config
require("lspconfig").lua_ls.setup(vim.tbl_extend("error", lua_ls_config, {
	root_dir = function()
		return vim.fs.joinpath(nvimrc_dir, "config", "nvim")
	end,
}))
