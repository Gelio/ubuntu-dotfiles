return {
	{
		"Saecki/crates.nvim",
		event = "BufRead Cargo.toml",
		branch = "main",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		},
	},
}
