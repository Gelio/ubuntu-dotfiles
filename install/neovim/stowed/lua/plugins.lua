vim.cmd([[packadd packer.nvim]])

vim.cmd([[
  augroup RecompilePlugins
    autocmd! BufWritePost plugins.lua source <afile> | PackerCompile
  augroup END
]])
map = vim.api.nvim_set_keymap

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	use("tpope/vim-sensible")
	use("tpope/vim-surround")
	use("tpope/vim-repeat")
	use("wellle/targets.vim")
	use("tpope/vim-unimpaired")
	use("tpope/vim-commentary")

	use({
		"bkad/camelcasemotion",
		config = function()
			vim.g.camelcasemotion_key = "<Leader>"
		end,
	})

	use("machakann/vim-highlightedyank")

	use({
		"kyazdani42/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({
				default = true,
			})
		end,
	})

	use({
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			map("n", "<Leader>nn", ":NvimTreeToggle<CR>", { noremap = true })
			map("n", "<Leader>nr", ":NvimTreeFindFile<CR>", { noremap = true })
			map("n", "<Leader>nR", ":NvimTreeFindFile<CR> :wincmd p<CR>", { noremap = true, silent = true })
			vim.g.nvim_tree_git_hl = 1
			vim.g.nvim_tree_lsp_diagnostics = 1
		end,
	})

	use({
		"hoob3rt/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("lualine").setup({
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = { "filename" },
					lualine_x = { { "diagnostics", sources = { "nvim_lsp" } }, "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				extensions = { "fugitive", "nvim-tree", "quickfix" },
			})
		end,
	})

	use({
		"alvarosevilla95/luatab.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			vim.o.tabline = "%!v:lua.require'luatab'.tabline()"
		end,
	})

	use("tpope/vim-fugitive")
	use("tpope/vim-rhubarb")
	use("junegunn/gv.vim")
	use({
		"rickhowe/diffchar.vim",
		after = "vim-unimpaired",
	})
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
			require("nvim-autopairs.completion.compe").setup({
				map_cr = true,
				map_complete = true,
				auto_select = false,
			})
		end,
	})
	use({
		"ggandor/lightspeed.nvim",
		config = function()
			require("lightspeed").setup({
				highlight_unique_chars = true,
			})
		end,
	})

	use({
		"mbbill/undotree",
		config = function()
			vim.o.undofile = true
			map("n", "<Leader>u", ":UndotreeToggle<CR>", { noremap = true })
		end,
	})

	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup()
		end,
	})
	use({
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	})
	use("kevinhwang91/nvim-bqf")
	use("tpope/vim-obsession")
	use({
		"sainnhe/gruvbox-material",
		config = function()
			vim.o.termguicolors = true
			vim.o.cursorline = true
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
			vim.g.gruvbox_material_diagnostic_text_highlight = 1
			vim.g.gruvbox_material_diagnostic_line_highlight = 1
			vim.g.gruvbox_material_ui_contrast = "high"
			vim.cmd("colorscheme gruvbox-material")
		end,
	})

	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			vim.g.indent_blankline_use_treesitter = true
			vim.g.indent_blankline_show_current_context = true
			vim.g.indent_blankline_context_highlight_list = { "Warning" }
			vim.g.indent_blankline_context_patterns = {
				"class",
				"function",
				"method",
				"if_statement",
				"else_clause",
				"jsx_element",
				"jsx_self_closing_element",
				"try_statement",
				"catch_clause",
				"object",
				"arguments",
				"table",
			}
		end,
		requires = "nvim-treesitter/nvim-treesitter",
	})

	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	})
	use({
		"lewis6991/gitsigns.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("gitsigns").setup()
		end,
	})

	use({
		"gelguy/wilder.nvim",
		config = function()
			-- Use a vimscript file because of a bug with using line continuations
			-- See https://github.com/gelguy/wilder.nvim/issues/53
			-- TODO: use <sfile>
			vim.cmd([[source $HOME/.config/nvim/wilder.vim]])
		end,
	})

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			map("n", "<Leader>ff", "<cmd>Telescope find_files hidden=true<CR>", { noremap = true })
			map("n", "<Leader>fg", "<cmd>Telescope live_grep<CR>", { noremap = true })
			map("n", "<Leader>fb", "<cmd>Telescope buffers<CR>", { noremap = true })
			map("n", "<Leader>fh", "<cmd>Telescope help_tags<CR>", { noremap = true })
			map("n", "<Leader>ft", "<cmd>Telescope treesitter<CR>", { noremap = true })
			map("n", "<Leader>fo", "<cmd>Telescope oldfiles<CR>", { noremap = true })
			map("n", "<Leader>fr", "<cmd>Telescope lsp_references<CR>", { noremap = true })
			map("n", "<Leader>fs", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { noremap = true })
			map("n", "<Leader>fac", "<cmd>Telescope lsp_code_actions<CR>", { noremap = true })

			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { ".git/.*" },
				},
			})
		end,
	})

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		config = function()
			vim.o.hidden = true
			vim.o.writebackup = false
			vim.o.swapfile = false
			vim.o.cmdheight = 2
			vim.opt.shortmess:append("c")
			vim.o.signcolumn = "yes"

			require("lsp")
		end,
	})

	use({
		"nvim-lua/lsp_extensions.nvim",
		config = function()
			local inlay_hints_options = {
				prefix = "",
				highlight = "Comment",
				enabled = { "TypeHint", "ChainingHint", "ParameterHint" },
			}
			vim.cmd("augroup LspExtensions")
			vim.cmd("autocmd!")
			vim.cmd(
				[[autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints ]]
					.. vim.inspect(inlay_hints_options, { newline = "" })
			)
			vim.cmd("augroup END")
		end,
	})
	use({
		"simrat39/symbols-outline.nvim",
		config = function()
			map("n", "<Leader>so", ":SymbolsOutline<CR>", { noremap = true })
			require("symbols-outline").setup({})
		end,
	})
	use({
		"hrsh7th/nvim-compe",
		config = function()
			vim.opt.completeopt = { "menuone", "noselect" }
			map("i", "<C-Space>", "compe#complete()", { silent = true, expr = true, noremap = true })
			map("i", "<C-y>", [[compe#close('<C-e>')]], { silent = true, expr = true, noremap = true })
			map("i", "<C-u>", [[compe#scroll({ 'delta': +4 })]], { silent = true, expr = true, noremap = true })
			map("i", "<C-d>", [[compe#scroll({ 'delta': -4 })]], { silent = true, expr = true, noremap = true })
		end,
	})

	use({
		"folke/trouble.nvim",
		config = function()
			map("n", "<Leader>xx", "<cmd>TroubleToggle<CR>", { noremap = true })
			map("n", "<Leader>xw", "<cmd>TroubleToggle lsp_workspace_diagnostics<CR>", { noremap = true })
			map("n", "<Leader>xd", "<cmd>TroubleToggle lsp_document_diagnostics<CR>", { noremap = true })
			map("n", "<Leader>xq", "<cmd>TroubleToggle quickfix<CR>", { noremap = true })
			map("n", "gR", "<cmd>TroubleToggle lsp_referenced<CR>", { noremap = true })
			require("trouble").setup({})
		end,
	})
	use("jose-elias-alvarez/nvim-lsp-ts-utils")
	use("jose-elias-alvarez/null-ls.nvim")
	use("ray-x/lsp_signature.nvim")

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = {
			"nvim-treesitter/playground",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"romgrk/nvim-treesitter-context",
			"RRethy/nvim-treesitter-textsubjects",
			"p00f/nvim-ts-rainbow",
			"windwp/nvim-ts-autotag",
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			vim.o.foldmethod = "expr"
			vim.o.foldexpr = "nvim_treesitter#foldexpr()"
			vim.o.foldlevel = 20

			require("nvim-treesitter.configs").setup({
				ensure_installed = "maintained",
				highlight = {
					enable = true,
				},
				autotag = {
					enable = true,
				},
				context_commentstring = {
					enable = true,
				},
				textsubjects = {
					enable = true,
					keymaps = {
						["."] = "textsubjects-smart",
						[";"] = "textsubjects-container-outer",
					},
				},
				textobjects = {
					swap = {
						enable = true,
						swap_next = {
							["]a"] = "@parameter.inner",
						},
						swap_previous = {
							["[a"] = "@parameter.inner",
						},
					},
					select = {
						enable = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@call.outer",
							["ic"] = "@call.inner",
						},
					},
				},
				rainbow = {
					enable = true,
					extended_mode = true,
				},
			})
		end,
	})

	use("editorconfig/editorconfig-vim")
	use("sudormrfbin/cheatsheet.nvim")
	use({
		"abecodes/tabout.nvim",
		config = function()
			require("tabout").setup({
				tabkey = "<Tab>",
				backwards_tabkey = "<S-Tab>",
				act_as_tab = true,
				act_as_shift_tab = false,
				completion = false,
				enable_backwards = true,
				tabouts = {
					{ open = "'", close = "'" },
					{ open = '"', close = '"' },
					{ open = "`", close = "`" },
					{ open = "(", close = ")" },
					{ open = "[", close = "]" },
					{ open = "{", close = "}" },
				},
				ignore_beginning = true,
			})
		end,
		wants = { "nvim-treesitter" },
	})
	use("aklt/plantuml-syntax")
	use({
		"vuki656/package-info.nvim",
		config = function()
			require("package-info").setup()
		end,
	})

	use({
		"rmagatti/goto-preview",
		config = function()
			map("n", "gpd", [[<cmd>lua require('goto-preview').goto_preview_definition()<CR>]], { noremap = true })
			map("n", "gpi", [[<cmd>lua require('goto-preview').goto_preview_implementation()<CR>]], { noremap = true })
			map("n", "gP", [[<cmd>lua require('goto-preview').close_all_win()<CR>]], { noremap = true })
			require("goto-preview").setup({})
		end,
	})

	use({
		"sindrets/diffview.nvim",
		config = function()
			require("diffview").setup({})
		end,
	})
end)