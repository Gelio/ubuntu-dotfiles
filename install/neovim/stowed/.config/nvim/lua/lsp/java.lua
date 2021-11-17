local M = {}

function M.setup()
	local HOME = vim.fn.expand("$HOME")
	local utils = require("lsp.utils")

	local bundles = {
		vim.fn.glob(
			HOME .. "/.local/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
		),
	}
	vim.list_extend(bundles, vim.split(vim.fn.glob(HOME .. "/.local/vscode-java-test/server/*.jar"), "\n"))

	M.config = vim.tbl_extend("error", utils.base_config, {
		cmd = { "java-jdtls.sh" },
		init_options = {
			bundles = bundles,
		},
	})

	local jdtls = require("jdtls")
	M.config.on_attach = utils.run_all(M.config.on_attach, function()
		jdtls.setup_dap({ hotcodereplace = "auto" })
	end)

	-- selene: allow(global_usage)
	function _G.start_java_lsp()
		jdtls.start_or_attach(M.config)
	end

	vim.cmd([[
    augroup LSPJava
      autocmd! FileType java lua start_java_lsp()
    augroup END
  ]])
end

return M
