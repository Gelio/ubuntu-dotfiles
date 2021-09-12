local M = {}

function M.setup()
	-- selene: allow(global_usage)
	function _G.start_java_lsp()
		local config = vim.tbl_extend("error", require("lsp.utils").base_config, {
			cmd = { "java-jdtls.sh" },
		})
		require("jdtls").start_or_attach(config)
	end

	vim.cmd([[
    augroup LSPJava
      autocmd! FileType java lua start_java_lsp()
    augroup END
  ]])
end

return M
