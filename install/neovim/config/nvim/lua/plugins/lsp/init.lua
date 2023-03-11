return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- TODO: extract these options elsewhere
			vim.o.cmdheight = 2
			vim.opt.shortmess:append("c")

			require("lsp")
		end,
		dependencies = {
			"jose-elias-alvarez/typescript.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			"mfussenegger/nvim-jdtls",
			"b0o/SchemaStore.nvim",
			{ "williamboman/mason.nvim", config = true },
			{ "williamboman/mason-lspconfig.nvim", config = true },
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "narutoxy/dim.lua", config = true },
			"Gelio/auto-nvimrc",
			{ "ray-x/lsp_signature.nvim", config = true },
		},
	},

	{
		"simrat39/symbols-outline.nvim",
		cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
		keys = {
			{ "<Leader>so", ":SymbolsOutline<CR>", "Symbols outline" },
		},
		config = function()
			require("symbols-outline").setup({
				show_numbers = true,
				show_relative_numbers = true,
			})
		end,
	},
	{
		"kosayoda/nvim-lightbulb",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				desc = "Show lightbulb in the signcolumn whenever an LSP action is available",
				group = vim.api.nvim_create_augroup("LspLightBulb", {}),
				callback = require("nvim-lightbulb").update_lightbulb,
				pattern = "*",
			})
		end,
	},

	{
		"weilbith/nvim-code-action-menu",
		cmd = "CodeActionMenu",
	},
}
