return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		config = function()
			vim.opt.completeopt = { "menuone", "noselect" }
			vim.opt.shortmess:append("c")
			require("cmp-natural-dates").setup()

			local function prepare_sources()
				-- NOTE: order matters. The order will be maintained in completions popup
				local sources = {
					{ name = "nvim_lsp", label = "LSP" },
					{ name = "crates", label = "crates.nvim" },
					{ name = "natural_dates", label = "date" },
					{ name = "npm" },
					{ name = "luasnip" },
					{ name = "nvim_lua" },
					{ name = "path" },
					{
						name = "buffer",
						keyword_length = 4,
						-- See https://github.com/hrsh7th/cmp-buffer#visible-buffers
						option = {
							get_bufnrs = function()
								local bufs = {}
								for _, win in ipairs(vim.api.nvim_list_wins()) do
									bufs[vim.api.nvim_win_get_buf(win)] = true
								end
								return vim.tbl_keys(bufs)
							end,
						},
					},
					{ name = "tmux", keyword_length = 4 },
					{ name = "calc" },
					{ name = "emoji" },
				}

				local source_labels = {}

				for _, source in ipairs(sources) do
					source_labels[source.name] = string.format("[%s]", source.label or source.name)
				end

				return sources, source_labels
			end

			local sources, source_labels = prepare_sources()

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
					require("lspkind").init()
				end,
			},
			{
				"L3MON4D3/LuaSnip",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip").config.set_config({
						update_events = "TextChanged,TextChangedI",
					})
					require("snippets").setup()

					-- https://github.com/L3MON4D3/LuaSnip#keymaps
					vim.cmd([[
	          imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
	          inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

	          snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
	          snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

	          imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
	          smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
	        ]])
				end,
			},
			"saadparwaiz1/cmp_luasnip",
		},
	},
}
