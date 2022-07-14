local nvimrc_dir = vim.fn.expand("<sfile>:p:h")

local null_ls = require("null-ls")
null_ls.deregister({ name = "selene" })
null_ls.register(null_ls.builtins.diagnostics.selene.with({
	name = "selene",
	cwd = function()
		return nvimrc_dir
	end,
}))
