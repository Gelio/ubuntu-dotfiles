vim.cmd([[packadd packer.nvim]])

vim.cmd([[
  augroup RecompilePlugins
    autocmd! BufWritePost plugins.lua source <afile> | PackerCompile
  augroup END
]])

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	use("tpope/vim-sensible")
	use("tpope/vim-surround")
	use("tpope/vim-repeat")
	use("wellle/targets.vim")
	use("tpope/vim-unimpaired")
	use("tpope/vim-commentary")

	use({
		"ojroques/vim-oscyank",
		config = function()
			-- NOTE: automatically synchronize clipboard yanking to parent terminal when using SSH
			local function is_ssh_connection()
				local ssh_connection = vim.env.SSH_CONNECTION
				return ssh_connection ~= nil and ssh_connection ~= ""
			end

			if is_ssh_connection() then
				vim.cmd([[
          autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | OSCYankReg + | endif
        ]])
			end
		end,
	})

	use({
		"bkad/camelcasemotion",
		config = function()
			vim.g.camelcasemotion_key = "<Leader>"
		end,
	})

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
			require("which-key").register({
				name = "NvimTree",
				n = { ":NvimTreeToggle<CR>", "Toggle NvimTree" },
				r = { ":NvimTreeFindFile<CR>", "Find current file in NvimTree" },
				R = {
					":NvimTreeFindFile<CR> :wincmd p<CR>",
					"Find current file but keep focus",
				},
			}, {
				prefix = "<Leader>n",
			})
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
	use("shumphrey/fugitive-gitlab.vim")
	use("junegunn/gv.vim")
	use({
		"rickhowe/diffchar.vim",
		after = "vim-unimpaired",
	})
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
			require("nvim-autopairs.completion.cmp").setup({
				map_cr = true,
				map_complete = false,
				auto_select = false,
			})
		end,
		requires = { "hrsh7th/nvim-cmp" },
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
			require("which-key").register({ ["<Leader>u"] = { ":UndotreeToggle<CR>", "Toggle undo tree" } })
		end,
	})

	use({
		"folke/which-key.nvim",
		config = function()
			local ws = require("which-key")
			ws.setup({
				operators = {
					["<Leader>y"] = "Yank to clipboard",
				},
			})
			ws.register({
				J = { ":m '>+1<CR>gv=gv", "Move lines below" },
				K = { ":m '<-2<CR>gv=gv", "Move lines above" },
				["<"] = { "<gv", "Deindent lines" },
				[">"] = { ">gv", "Indent lines" },
				["<Leader>y"] = "Yank to clipboard",
			}, {
				mode = "v",
			})

			ws.register({
				["cn"] = { "*``cgn", "Search and replace" },
				["cN"] = { "*``cgN", "Search and replace backwards" },
				J = { "mzJ`z", "Join lines" },
				["<Leader>y"] = "Yank to clipboard",
			})
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
			local vimgrep_args_hidden_files = require("telescope.config").set_defaults().get("vimgrep_arguments")
			table.insert(vimgrep_args_hidden_files, "--hidden")

			require("which-key").register({
				name = "Telescope",
				f = { "<cmd>Telescope find_files hidden=true<CR>", "Files" },
				g = {
					function()
						require("telescope.builtin").live_grep({ vimgrep_arguments = vimgrep_args_hidden_files })
					end,
					"Grep",
				},
				G = {
					name = "Git",
					s = { "<cmd>Telescope git_status<CR>", "Status" },
					f = { "<cmd>Telescope git_files<CR>", "Files" },
					b = { "<cmd>Telescope git_branches<CR>", "Branches" },
				},
				b = { "<cmd>Telescope buffers<CR>", "Buffers" },
				h = { "<cmd>Telescope help_tags<CR>", "Help tags" },
				t = { "<cmd>Telescope treesitter<CR>", "Treesitter" },
				o = { "<cmd>Telescope oldfiles<CR>", "Old files" },
				r = { "<cmd>Telescope lsp_references<CR>", "LSP references" },
				s = { "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "LSP workspace symbols" },
				["ac"] = { "<cmd>Telescope lsp_code_actions<CR>", "LSP code actions" },
			}, {
				prefix = "<Leader>f",
			})

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
		requires = {
			"jose-elias-alvarez/nvim-lsp-ts-utils",
			"jose-elias-alvarez/null-ls.nvim",
		},
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
			require("which-key").register({ ["<Leader>so"] = { ":SymbolsOutline<CR>", "Symbols outline" } })
			require("symbols-outline").setup({})
		end,
	})

	use({
		"hrsh7th/nvim-cmp",
		config = function()
			vim.opt.completeopt = { "menuone", "noselect" }

			local function prepare_sources()
				-- NOTE: order matters. The order will be maintained in completions popup
				local sources = {
					{ name = "nvim_lsp", label = "LSP" },
					{ name = "crates", label = "crates.nvim" },
					{ name = "vsnip" },
					{ name = "nvim_lua" },
					{ name = "path" },
					{ name = "buffer" },
					{ name = "tmux" },
					{ name = "calc" },
					{ name = "emoji" },
				}

				local source_labels = {}

				for _, source in pairs(sources) do
					source_labels[source.name] = source.label or source.name
				end

				return sources, source_labels
			end

			local sources, source_labels = prepare_sources()

			local function format(entry, vim_item)
				vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
				vim_item.menu = source_labels[entry.source.name]
				return vim_item
			end

			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = {
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-y>"] = cmp.mapping.close(),
					["<C-u>"] = cmp.mapping.scroll_docs(4),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					-- NOTE: mapping for <CR> is added by nvim-autopairs
				},
				sources = sources,
				formatting = { format = format },
			})

			-- https://github.com/hrsh7th/vim-vsnip#2-setting
			vim.cmd([[
        imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
        smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
        imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
        smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
      ]])
		end,
		requires = {
			"hrsh7th/vim-vsnip",
			"hrsh7th/vim-vsnip-integ",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/cmp-buffer",
			"Saecki/crates.nvim",
			"hrsh7th/cmp-path",
			{ "andersevenrud/compe-tmux", branch = "cmp" },
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-nvim-lsp",
			"rafamadriz/friendly-snippets",
			"hrsh7th/cmp-emoji",
			"onsails/lspkind-nvim",
		},
	})

	use({
		"folke/trouble.nvim",
		config = function()
			local ws = require("which-key")
			ws.register({
				name = "Trouble",
				x = { "<cmd>TroubleToggle<CR>", "Toggle" },
				w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<CR>", "Workspace diagnostics" },
				d = { "<cmd>TroubleToggle lsp_document_diagnostics<CR>", "Document diagnostics" },
				q = { "<cmd>TroubleToggle quickfix<CR>", "Quickfix" },
			}, {
				prefix = "<Leader>x",
			})
			ws.register({
				["gR"] = { "<cmd>TroubleToggle lsp_references<CR>", "Trouble LSP references" },
			})
		end,
	})
	use("jose-elias-alvarez/nvim-lsp-ts-utils")
	use("jose-elias-alvarez/null-ls.nvim")
	use("ray-x/lsp_signature.nvim")
	use({
		"onsails/lspkind-nvim",
		config = function()
			require("lspkind").init()
		end,
	})

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
	use("aklt/plantuml-syntax")
	use({ "ekalinin/dockerfile.vim" })
	use({
		"vuki656/package-info.nvim",
		config = function()
			require("package-info").setup()
		end,
	})

	use({
		"rmagatti/goto-preview",
		config = function()
			require("which-key").register({
				["gpd"] = { [[<cmd>lua require('goto-preview').goto_preview_definition()<CR>]], "Preview definitions" },
				["gpi"] = {
					[[<cmd>lua require('goto-preview').goto_preview_implementation()<CR>]],
					"Preview implementations",
				},
				["gP"] = { [[<cmd>lua require('goto-preview').close_all_win()<CR>]], "Close preview windows" },
			})
			require("goto-preview").setup({})
		end,
	})

	use({
		"sindrets/diffview.nvim",
		config = function()
			require("diffview").setup({})
		end,
	})

	use("dstein64/nvim-scrollview")
	use({
		"monaqa/dial.nvim",
		config = function()
			local ws = require("which-key")
			ws.register({
				["<C-a>"] = { "<Plug>(dial-increment)" },
				["<C-x>"] = { "<Plug>(dial-decrement)" },
			})
			ws.register({
				["<C-a>"] = { "<Plug>(dial-increment)" },
				["<C-x>"] = { "<Plug>(dial-decrement)" },
				["g<C-a>"] = { "<Plug>(dial-increment-additional)", "Increment sequential" },
				["g<C-x>"] = { "<Plug>(dial-decrement-additional)", "Decrement sequential" },
			}, {
				mode = "v",
			})
		end,
	})
end)