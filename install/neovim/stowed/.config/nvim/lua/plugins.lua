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
		use({
			"tpope/vim-unimpaired",
			setup = function()
				vim.g.nremap = {
					-- Disable encoding and decoding maps
					["[u"] = "",
					["]u"] = "",
					["[y"] = "",
					["]y"] = "",
					["[x"] = "",
					["]x"] = "",
					["[C"] = "",
					["]C"] = "",
				}
			end,
		})
		use({
			"echasnovski/mini.nvim",
			config = function()
				require("mini.trailspace").setup({
					only_in_normal_buffers = true,
				})
			end,
		})
		use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })
		use({ "nathom/filetype.nvim" })

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
					git = {
						ignore = true,
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
				local dap_extension = {
					sections = {
						lualine_a = { "mode", "filename" },
					},
					inactive_sections = {
						lualine_a = { "filename" },
					},
					filetypes = {
						"dapui_scopes",
						"dapui_watches",
						"dapui_stacks",
						"dapui_breakpoints",
						"dap-repl",
					},
				}
				--- Source: https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#truncating-components-in-smaller-window
				--- @param trunc_width number trunctates component when screen width is less than trunc_width
				--- @param trunc_len number truncates component to trunc_len number of chars
				--- @param hide_width number hides component when window width is smaller then hide_width
				--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
				--- return function that can format the component accordingly
				local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
					return function(str)
						local win_width = vim.fn.winwidth(0)
						if hide_width and win_width < hide_width then
							return ""
						elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
							return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
						end
						return str
					end
				end

				require("lualine").setup({
					options = { theme = "gruvbox-material" },
					sections = {
						lualine_a = { "mode" },
						lualine_b = { { "branch", fmt = trunc(150, 20, 100) } },
						lualine_c = {
							{
								"filename",
								path = 1, -- NOTE: show relative file path
							},
						},
						lualine_x = {
							{
								"diagnostics",
								sources = { "nvim_diagnostic" },
								diagnostics_color = {
									error = "VirtualTextError",
									warn = "VirtualTextWarn",
									info = "VirtualTextInfo",
									hint = "VirtualTextHint",
								},
							},
							{ "encoding", fmt = trunc(nil, nil, 150) },
							{ "fileformat", fmt = trunc(nil, nil, 150) },
							{ "filetype", fmt = trunc(150, 8) },
						},
						lualine_y = { "progress" },
						lualine_z = { "location" },
					},
					extensions = { "fugitive", "nvim-tree", "quickfix", dap_extension, "symbols-outline" },
				})
			end,
		})

		use({
			"alvarosevilla95/luatab.nvim",
			requires = "kyazdani42/nvim-web-devicons",
			config = function()
				require("luatab").setup({})
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
				autopairs.setup({
					disable_in_macro = true,
				})
			end,
		})
		use({
			"ggandor/lightspeed.nvim",
			config = function()
				require("lightspeed").setup({})
				-- NOTE: workaround for https://github.com/ggandor/lightspeed.nvim/issues/73
				vim.cmd([[
          autocmd User LightspeedLeave set scrolloff=5
        ]])
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
				require("todo-comments").setup({
					colors = {
						info = { "VirtualTextInfo" },
						default = { "Aqua" },
					},
				})
			end,
		})
		use({
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup({
					pre_hook = function(ctx)
						if vim.bo.filetype == "typescriptreact" then
							local U = require("Comment.utils")

							-- Detemine whether to use linewise or blockwise commentstring
							local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"

							-- Determine the location where to calculate commentstring from
							local location = nil
							if ctx.ctype == U.ctype.block then
								location = require("ts_context_commentstring.utils").get_cursor_location()
							elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
								location = require("ts_context_commentstring.utils").get_visual_start_location()
							end

							return require("ts_context_commentstring.internal").calculate_commentstring({
								key = type,
								location = location,
							})
						end
					end,
				})
			end,
			requires = {
				"JoosepAlviste/nvim-ts-context-commentstring",
			},
		})
		use({ "kevinhwang91/nvim-bqf", ft = "qf" })
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
					show_current_context_start = true,
					context_highlight_list = { "Blue" },

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
				local gitsigns = require("gitsigns")
				gitsigns.setup({
					on_attach = function(bufnr)
						local which_key = require("which-key")

						which_key.register({
							["[c"] = {
								"&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'",
								"Move to previous hunk",
								expr = true,
							},
							["]c"] = {
								"&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'",
								"Move to next hunk",
								expr = true,
							},
						}, { buffer = bufnr })

						local function get_selected_line_range(mode)
							if mode ~= "v" then
								return nil
							end

							-- NOTE: the '< and '> return the **last** visual selection
							-- and have stale values.
							-- I didn't find a way to reliably exit visual mode prior to reading
							-- them. Thus, use this method below to get the current selection
							-- and exit visual mode in a non-blocking way
							-- NOTE: sometimes start_line_number > end_line_number
							-- gitsigns seems to handle that
							local start_line_number = vim.fn.line("v")
							local end_line_number = vim.fn.getcurpos()[2]

							-- NOTE: exit visual mode
							vim.api.nvim_input("<esc>")

							return { start_line_number, end_line_number }
						end

						local function register_stage_unstage_hunk(mode)
							which_key.register({
								name = "gitsigns",
								s = {
									function()
										gitsigns.stage_hunk(get_selected_line_range(mode))
									end,
									"Stage hunk",
								},
								r = {
									function()
										gitsigns.reset_hunk(get_selected_line_range(mode))
									end,
									"Reset hunk",
								},
							}, {
								mode = mode,
								prefix = "<leader>h",
								buffer = bufnr,
							})
						end

						register_stage_unstage_hunk("n")
						register_stage_unstage_hunk("v")

						which_key.register({
							name = "gitsigns",
							t = {
								name = "Toggle",
								d = { gitsigns.toggle_deleted, "Toggle deleted lines" },
								b = { gitsigns.toggle_current_line_blame, "Toggle current line blame" },
							},
							b = {
								function()
									gitsigns.blame_line({ full = true })
								end,
								"Blame current line",
							},
							R = { gitsigns.reset_buffer, "Reset changes in buffer" },
							p = { gitsigns.preview_hunk, "Preview hunk" },
							u = { gitsigns.undo_stage_hunk, "Unstage last hunk" },
						}, {
							prefix = "<leader>h",
							buffer = bufnr,
						})
					end,
				})
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
						file_ignore_patterns = { ".git/.*", ".yarn/.*" },
						path_display = { ["truncate"] = 2 },
					},
				})
			end,
		})

		-- LSP
		use({
			"neovim/nvim-lspconfig",
			config = function()
				vim.o.cmdheight = 2
				vim.opt.shortmess:append("c")

				require("lsp")
			end,
			requires = {
				"jose-elias-alvarez/nvim-lsp-ts-utils",
				"jose-elias-alvarez/null-ls.nvim",
				"mfussenegger/nvim-jdtls",
				"b0o/SchemaStore.nvim",
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
			-- NOTE: disable until https://github.com/simrat39/symbols-outline.nvim/issues/98 is fixed
			disable = true,
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
				"andersevenrud/cmp-tmux",
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
					w = { "<cmd>TroubleToggle workspace_diagnostics<CR>", "Workspace diagnostics" },
					d = { "<cmd>TroubleToggle document_diagnostics<CR>", "Document diagnostics" },
					q = { "<cmd>TroubleToggle quickfix<CR>", "Quickfix" },
				}, {
					prefix = "<Leader>t",
				})
				ws.register({
					["gR"] = { "<cmd>TroubleToggle lsp_references<CR>", "Trouble LSP references" },
				})
			end,
		})
		use({
			"ray-x/lsp_signature.nvim",
			config = function()
				require("lsp_signature").setup()
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

		use({
			"ThePrimeagen/refactoring.nvim",
			requires = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-treesitter/nvim-treesitter" },
				{ "folke/which-key.nvim" },
			},
			config = function()
				require("refactor").setup()
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
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("diffview").setup({})
			end,
		})

		use({
			"petertriho/nvim-scrollbar",
			config = function()
				local function to_hex_color(num)
					return string.format("#%06x", num)
				end
				local function get_highlight(name)
					return vim.api.nvim_get_hl_by_name(name, true)
				end

				require("scrollbar").setup({
					handle = {
						color = to_hex_color(get_highlight("Visual").background),
					},
					marks = {
						Search = { color = to_hex_color(get_highlight("Orange").foreground) },
						Error = { color = to_hex_color(get_highlight("VirtualTextError").foreground) },
						Warn = { color = to_hex_color(get_highlight("VirtualTextWarning").foreground) },
						Info = { color = to_hex_color(get_highlight("VirtualTextInfo").foreground) },
						Hint = { color = to_hex_color(get_highlight("VirtualTextHint").foreground) },
						Misc = { color = to_hex_color(get_highlight("Purple").foreground) },
					},
				})
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
						vim.o.wrap = true
						vim.o.list = true
						vim.o.linebreak = true
					end

					vim.cmd([[
            function! OnUIEnter(event) abort
              if 'Firenvim' ==# get(get(nvim_get_chan_info(a:event.chan), 'client', {}), 'name', '')
                lua _G.set_firenvim_settings()
              endif
            endfunction

            autocmd UIEnter * call OnUIEnter(deepcopy(v:event))

            au BufEnter github.com_*.txt,gitlab.com_*.txt,mattermost.*.txt,mail.google.com_*.txt set filetype=markdown
            au BufEnter mail.google.com_*.txt set tw=80
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

		use({
			"mfussenegger/nvim-dap",
			config = function()
				require("which-key").register({
					name = "Dap (debug)",
					b = { ":DapToggleBreakpoint<CR>", "Toggle breakpoint" },
					c = { ":DapContinue<CR>", "Continue" },
					s = {
						name = "Step",
						o = { ":DapStepOut<CR>", "Step out" },
						n = { ":DapStepOver<CR>", "Step over" },
						i = { ":DapStepInto<CR>", "Step into" },
						c = { ":DapRunToCursor<CR>", "Run to cursor" },
					},
				}, {
					prefix = "<Leader>x",
				})

				local dap = require("dap")
				local add_command = vim.api.nvim_add_user_command
				local utils = require("utils")

				-- TODO: support adding logpoints and conditional breakpoints
				add_command("DapToggleBreakpoint", utils.execute_function_without_args(dap.toggle_breakpoint), {})
				add_command("DapContinue", utils.execute_function_without_args(dap.continue), {})
				add_command("DapStepOver", utils.execute_function_without_args(dap.step_over), {})
				add_command("DapStepInto", utils.execute_function_without_args(dap.step_into), {})
				add_command("DapStepOut", utils.execute_function_without_args(dap.step_out), {})
				add_command("DapTerminate", utils.execute_function_without_args(dap.terminate), {})
				add_command("DapRunToCursor", utils.execute_function_without_args(dap.run_to_cursor), {})
				add_command("DapReplOpen", utils.execute_function_without_args(dap.repl.open), {})
				add_command("DapReplToggle", utils.execute_function_without_args(dap.repl.toggle), {})
				add_command("DapReplClose", utils.execute_function_without_args(dap.repl.close), {})
				add_command("DapStatus", function()
					print(dap.status())
				end, {})
			end,
		})

		use({
			"rcarriga/nvim-dap-ui",
			config = function()
				local dapui = require("dapui")
				dapui.setup()

				local add_command = vim.api.nvim_add_user_command
				local utils = require("utils")

				add_command("DapUIOpen", utils.execute_function_without_args(dapui.open), {})
				add_command("DapUIClose", utils.execute_function_without_args(dapui.close), {})
				add_command("DapUI", utils.execute_function_without_args(dapui.toggle), {})
				add_command("DapUIEval", function(args)
					dapui.eval(string.len(args.args) > 0 and args.args or nil)
				end, {
					nargs = "?",
				})

				require("which-key").register({
					K = { ":DapUIEval<CR>", "Evaluate expression under cursor" },
					x = { ":DapUI<CR>", "Toggle Dap UI" },
				}, {
					prefix = "<Leader>x",
				})
			end,
		})

		use({
			"iamcco/markdown-preview.nvim",
			run = "cd app && yarn install",
			config = function()
				vim.g.mkdp_echo_preview_url = true
			end,
		})

		use({
			"plasticboy/vim-markdown",
			config = function()
				vim.g.vim_markdown_no_extensions_in_markdown = true
			end,
			requires = {
				"godlygeek/tabular",
			},
		})
		use({ "mzlogin/vim-markdown-toc" })

		use({ "lervag/vimtex" })

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
