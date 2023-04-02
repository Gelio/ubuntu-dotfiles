return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp")
		end,
		dependencies = {
			"jose-elias-alvarez/typescript.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			"b0o/SchemaStore.nvim",
			{
				"williamboman/mason.nvim",
				config = true,
				build = ":MasonUpdate",
			},
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
			{ "<Leader>so", "<cmd>SymbolsOutline<CR>", "Symbols outline" },
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

	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		init = function()
			vim.diagnostic.config({
				virtual_lines = false,
				virtual_text = {
					source = "always",
				},
			})
		end,
		config = function()
			local lsp_lines = require("lsp_lines")
			lsp_lines.setup()

			vim.api.nvim_create_user_command("ToggleLspLines", function()
				local lines_enabled = vim.diagnostic.config().virtual_lines

				if lines_enabled then
					vim.diagnostic.config({
						virtual_lines = false,
						virtual_text = {
							source = "always",
						},
					})
				else
					vim.diagnostic.config({
						virtual_lines = true,
						virtual_text = false,
					})
				end
			end, {})
		end,
		cmd = { "ToggleLspLines" },
	},
}
