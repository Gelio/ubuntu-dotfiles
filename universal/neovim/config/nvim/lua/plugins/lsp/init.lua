return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp")
		end,
		dependencies = {
			{
				"pmizio/typescript-tools.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
				config = function()
					require("lsp.tsserver").setup()
				end,
			},
			{
				"mfussenegger/nvim-lint",
				event = { "BufReadPost", "BufNewFile" },
				config = function()
					local nvim_lint = require("lint")
					nvim_lint.linters_by_ft = require("lsp.nvim-lint").linters_by_ft

					vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWritePost" }, {
						group = vim.api.nvim_create_augroup("NvimLint", {}),
						callback = function()
							nvim_lint.try_lint()
						end,
					})
				end,
			},
			{
				"stevearc/conform.nvim",
				opts = {
					formatters_by_ft = require("lsp.conform-nvim").formatters_by_ft,
					format_on_save = {
						lsp_fallback = true,
						timeout_ms = 500,
					},
				},
				event = { "BufWritePre" },
				keys = {
					{
						"<Leader>F",
						function()
							require("conform").format({
								async = true,
								lsp_fallback = true,
							})
						end,
						mode = { "n", "v" },
						desc = "Format",
					},
				},
			},
			"b0o/SchemaStore.nvim",
			{
				"williamboman/mason.nvim",
				config = true,
				build = ":MasonUpdate",
			},
			{ "williamboman/mason-lspconfig.nvim", config = true },
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{
				"Gelio/auto-nvimrc",
				cmd = { "AutoNvimrcReset" },
				init = function()
					vim.api.nvim_create_user_command("AutoNvimrcReset", function()
						require("auto-nvimrc").reset()
					end, {})
				end,
			},
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
		opts = {
			autocmd = {
				enabled = true,
				-- NOTE: do not override the `updatetime` which is set elsewhere
				updatetime = -1,
			},
		},
	},

	{
		"Gelio/nvim-code-action-menu",
		branch = "stabilize-windows-widths",
		cmd = "CodeActionMenu",
	},
}
