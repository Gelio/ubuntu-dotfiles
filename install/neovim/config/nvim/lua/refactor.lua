local M = {}

function M.setup()
	require("refactoring").setup()
	require("telescope").load_extension("refactoring")

	require("which-key").register({
		name = "Refactor",
		t = { "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", "Choose a refactor" },
	}, {
		prefix = "<Leader>r",
		mode = "v",
	})
end

return M
