return {
	{
		"vuki656/package-info.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		event = "BufReadPre package.json",
		config = function()
			local package_info = require("package-info")
			package_info.setup()

			vim.api.nvim_create_autocmd("BufReadPost", {
				pattern = "package.json",
				callback = function()
					local buffer = vim.fn.bufnr()

					vim.keymap.set("n", "<Leader>pd", package_info.delete, { desc = "Delete package", buffer = buffer })
					vim.keymap.set(
						"n",
						"<Leader>pc",
						package_info.change_version,
						{ desc = "Change version", buffer = buffer }
					)
				end,
				group = vim.api.nvim_create_augroup("PackageInfoMappings", {}),
			})
		end,
	},
}
