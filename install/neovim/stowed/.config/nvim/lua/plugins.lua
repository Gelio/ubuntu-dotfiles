vim.cmd([[packadd packer.nvim]])

vim.cmd([[
  augroup RecompilePlugins
    autocmd! BufWritePost plugins.lua let g:plugins_recompile=1 | source <afile> | PackerCompile
  augroup END
]])

local function setup_packer(packer_bootstrap)
	require("packer").startup(function(use)
		use("wbthomason/packer.nvim")

		use("tpope/vim-sensible")
		use("tpope/vim-surround")
		use("tpope/vim-repeat")
		use("wellle/targets.vim")
		use("tpope/vim-unimpaired")
		use({
			"echasnovski/mini.nvim",
			config = function()
				require("mini.trailspace").setup({})
				vim.cmd([[ highlight! link MiniTrailspace TSDanger ]])
			end,
		})
		use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })

		use({
			"ojroques/vim-oscyank",
			config = function()
				-- NOTE: automatically synchronize clipboard yanking to parent terminal when using SSH
				vim.cmd([[
          autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | OSCYankReg + | endif
        ]])
			end,
			cond = function()
				local ssh_connection = vim.env.SSH_CONNECTION
				return ssh_connection ~= nil and ssh_connection ~= ""
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
				vim.g.nvim_tree_git_hl = 1
				vim.g.nvim_tree_group_empty = 1

				require("nvim-tree").setup({
					update_focused_file = {
						enable = true,
					},
					diagnostics = {
						enable = true,
					},
				})
				require("which-key").register({
					name = "NvimTree",
					n = { ":NvimTreeToggle<CR>", "Toggle NvimTree" },
					r = { ":NvimTreeFindFile<CR>", "Find file in NvimTree" },
					f = { ":NvimTreeFocus<CR>", "Focus NvimTree" },
				}, {
					prefix = "<Leader>n",
				})
			end,
		})

		use({
			"junegunn/vim-easy-align",
			config = function()
				-- NOTE: for some reason, which-key.nvim could not register this binding
				vim.cmd([[
          xmap ga <Plug>(EasyAlign)
        ]])
			end,
		})

		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
			config = function()
				require("lualine").setup({
					sections = {
						lualine_a = { "mode" },
						lualine_b = { "branch" },
						lualine_c = { "filename" },
						lualine_x = {
							{
								"diagnostics",
								sources = { "nvim_lsp" },
								diagnostics_color = {
									error = "VirtualTextError",
									warn = "VirtualTextWarn",
									info = "VirtualTextInfo",
									hint = "VirtualTextHint",
								},
							},
							"encoding",
							"fileformat",
							"filetype",
						},
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
				local autopairs = require("nvim-autopairs")
				autopairs.setup()
				autopairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))
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
		use({
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup({
					pre_hook = function()
						return require("ts_context_commentstring.internal").calculate_commentstring()
					end,
				})
			end,
			requires = {
				"JoosepAlviste/nvim-ts-context-commentstring",
			},
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
				require("indent_blankline").setup({
					use_treesitter = true,
					show_current_context = true,
					context_highlight_list = { "Blue" },
					context_patterns = {
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
						"return_statement",
						"formal_parameters",
						"^for",
						"^while",
						"arguments",
						"table", -- Lua tables
					},

					filetype_exclude = { "help" },
					buftype_exclude = { "terminal" },
					bufname_exclude = { "" }, -- Disables the plugin in hover() popups and new files

					char_highlight_list = { "VertSplit" },

					-- NOTE: alternating indentation highlight
					space_char_highlight_list = { "MsgSeparator", "Normal" },
				})
			end,
			requires = "nvim-treesitter/nvim-treesitter",
		})

		use({
			"lukas-reineke/headlines.nvim",
			config = function()
				require("headlines").setup()
			end,
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

				vim.cmd([[call wilder#main#start()]])
			end,
			run = ":UpdateRemotePlugins",
			event = "CmdlineEnter",
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
						path_display = { ["truncate"] = 2 },
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
				vim.o.signcolumn = "auto"

				require("lsp")
			end,
			requires = {
				"jose-elias-alvarez/nvim-lsp-ts-utils",
				"jose-elias-alvarez/null-ls.nvim",
				"mfussenegger/nvim-jdtls",
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
						{ name = "npm" },
						{ name = "vsnip" },
						{ name = "nvim_lua" },
						{ name = "path" },
						{ name = "buffer", keyword_length = 4 },
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
						["<CR>"] = cmp.mapping.confirm({ select = false }),
					},
					sources = sources,
					formatting = {
						format = require("lspkind").cmp_format({ with_text = true, menu = source_labels }),
					},
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
			"Saecki/crates.nvim",
			event = { "BufRead Cargo.toml" },
			branch = "main",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("crates").setup()
			end,
		})
		use({
			"David-Kunz/cmp-npm",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("cmp-npm").setup({})
			end,
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
		use({
			"ray-x/lsp_signature.nvim",
			config = function()
				vim.cmd([[highlight! link LspSignatureActiveParameter WildMenu]])
			end,
		})
		use({
			"onsails/lspkind-nvim",
			config = function()
				require("lspkind").init()
			end,
		})
		use({
			"kosayoda/nvim-lightbulb",
			config = function()
				-- selene: allow(global_usage)
				function _G.update_lightbulb()
					require("nvim-lightbulb").update_lightbulb()
				end

				vim.cmd([[
          augroup LspLightBulb
            autocmd! CursorHold,CursorHoldI * lua _G.update_lightbulb()
          augroup END
        ]])
			end,
		})

		use({
			"weilbith/nvim-code-action-menu",
			cmd = "CodeActionMenu",
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
			requires = { "MunifTanjim/nui.nvim" },
			config = function()
				require("package-info").setup()
				-- selene: allow(global_usage)
				function _G.setup_package_info_mappings()
					require("which-key").register({
						pd = { "<cmd>lua require('package-info').delete()<CR>", "Delete package" },
						pc = { "<cmd>lua require('package-info').change_version()<CR>", "Install another version" },
					}, {
						prefix = "<Leader>",
						buffer = vim.fn.bufnr(),
					})
				end

				vim.cmd([[
          augroup PackageInfoMappings
            autocmd! BufEnter package.json lua _G.setup_package_info_mappings()
          augroup END
        ]])
			end,
		})

		use({
			"rmagatti/goto-preview",
			config = function()
				require("which-key").register({
					["gpd"] = {
						[[<cmd>lua require('goto-preview').goto_preview_definition()<CR>]],
						"Preview definitions",
					},
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

		use({
			"dstein64/nvim-scrollview",
			config = function()
				vim.cmd([[ highlight link ScrollView WildMenu ]])
			end,
			after = { "gruvbox-material" },
		})
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
		use({
			"sindrets/winshift.nvim",
			config = function()
				require("winshift").setup()
				require("which-key").register({
					["<C-M>"] = { "<cmd>WinShift<CR>", "Window shift mode" },
					["m"] = { "<cmd>WinShift<CR>", "Window shift mode" },
				}, {
					prefix = "<C-W>",
				})
			end,
		})
		use({
			"glacambre/firenvim",
			run = function()
				vim.fn["firenvim#install"](0)
			end,
			config = function()
				vim.g.firenvim_config = {
					localSettings = {
						[".*"] = {
							takeover = "never",
							priority = 0,
							cmdline = "neovim",
						},
					},
				}

				-- https://github.com/glacambre/firenvim#building-a-firenvim-specific-config
				if vim.g.started_by_firenvim then
					vim.o.cmdheight = 1
					-- selene: allow(global_usage)
					function _G.set_firenvim_settings()
						local min_lines = 18
						if vim.o.lines < min_lines then
							vim.o.lines = min_lines
						end
					end

					vim.cmd([[
            function! OnUIEnter(event) abort
              if 'Firenvim' ==# get(get(nvim_get_chan_info(a:event.chan), 'client', {}), 'name', '')
                lua _G.set_firenvim_settings()
              endif
            endfunction

            autocmd UIEnter * call OnUIEnter(deepcopy(v:event))

            au BufEnter github.com_*.txt,gitlab.com_*.txt,mattermost.*.txt set filetype=markdown
          ]])
				end
			end,
		})
		use({
			"chentau/marks.nvim",
			config = function()
				require("marks").setup({})
			end,
		})

		-- https://github.com/wbthomason/packer.nvim#bootstrapping
		if packer_bootstrap then
			require("packer").sync()
		end
	end)
end

if vim.g.plugins_recompile == 1 then
	setup_packer(false)
end

return setup_packer
