local M = {}

local null_ls = require("null-ls")

local prettierd_filetypes = { unpack(null_ls.builtins.formatting.prettierd.filetypes) }
table.insert(prettierd_filetypes, "graphql")
table.insert(prettierd_filetypes, "jsonc")

M.sources = {
	null_ls.builtins.formatting.prettierd.with({
		filetypes = prettierd_filetypes,
	}),
	null_ls.builtins.formatting.trim_whitespace.with({
		filetypes = { "plantuml" },
	}),
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.diagnostics.selene,
	null_ls.builtins.diagnostics.shellcheck,
	null_ls.builtins.formatting.shfmt,
	null_ls.builtins.diagnostics.hadolint,
	null_ls.builtins.diagnostics.markdownlint,
	null_ls.builtins.diagnostics.write_good,
	null_ls.builtins.diagnostics.misspell,
	null_ls.builtins.formatting.gofumpt,
}
null_ls.config({
	sources = M.sources,
})

M.config = require("lsp.utils").base_config

return M
