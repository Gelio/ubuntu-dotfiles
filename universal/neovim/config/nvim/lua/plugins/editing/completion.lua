return {
	{
		-- NOTE: use https://github.com/iguanacucumber/magazine.nvim until nvim-cmp
		-- starts being maintained again
		"iguanacucumber/magazine.nvim",
		name = "nvim-cmp",
		event = "InsertEnter",
		config = function()
			vim.opt.completeopt = { "menuone", "noselect" }
			vim.opt.shortmess:append("c")

			local sources, source_labels = require("lsp.cmp").prepare_sources()

			local cmp = require("cmp")
			local lsp_utils = require("lsp.utils")
			cmp.setup({
				window = {
					completion = {
						zindex = lsp_utils.zindex.completions_menu,
					},
					documentation = {
						zindex = lsp_utils.zindex.completion_documentation,
					},
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
				}),
				sources = sources,
				formatting = {
					format = require("lspkind").cmp_format({ mode = "symbol_text", menu = source_labels }),
				},
			})
		end,
		dependencies = {
			"hrsh7th/cmp-buffer",
			{
				"Saecki/crates.nvim",
				event = "BufRead Cargo.toml",
				branch = "main",
				dependencies = { "nvim-lua/plenary.nvim" },
				config = true,
			},
			"hrsh7th/cmp-path",
			"andersevenrud/cmp-tmux",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-nvim-lsp",
			"rafamadriz/friendly-snippets",
			{
				"Gelio/cmp-natdat",
				opts = {
					cmp_kind_text = "NatDat",
				},
			},
			"hrsh7th/cmp-emoji",
			{
				"David-Kunz/cmp-npm",
				lazy = true,
				dependencies = { "nvim-lua/plenary.nvim" },
				config = true,
				event = "BufRead package.json",
			},
			{
				"onsails/lspkind-nvim",
				config = function()
					require("lspkind").init({
						symbol_map = {
							NatDat = "📅",
						},
					})
				end,
			},
			{
				"L3MON4D3/LuaSnip",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					local ls = require("luasnip")
					ls.config.set_config({
						update_events = "TextChanged,TextChangedI",
					})
					require("snippets").setup()

					-- https://github.com/L3MON4D3/LuaSnip#keymaps
					vim.keymap.set({ "i", "s" }, "<C-L>", function()
						ls.expand_or_jump()
					end, { silent = true })
					vim.keymap.set({ "i", "s" }, "<C-H>", function()
						ls.jump(-1)
					end, { silent = true })

					vim.keymap.set({ "i", "s" }, "<C-E>", function()
						if ls.choice_active() then
							ls.change_choice(1)
						end
					end, { silent = true })

					vim.keymap.set("s", "<BS>", "<C-O>s", {
						-- https://github.com/L3MON4D3/LuaSnip/issues/622#issuecomment-1275350599
						desc = "Delete current selection without existing snippet mode",
					})
				end,
			},
			"saadparwaiz1/cmp_luasnip",
		},
	},
}
