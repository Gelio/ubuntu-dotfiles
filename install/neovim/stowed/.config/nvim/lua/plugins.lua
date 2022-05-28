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
		use({ "lewis6991/impatient.nvim" })

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
				require("nvim-tree").setup({
					hijack_netrw = true,
					diagnostics = {
						enable = true,
					},
					view = {
						number = true,
						relativenumber = true,
						mappings = {
							list = {
								-- NOTE: default to editing the file in place, netrw-style
								{
									key = { "<C-e>", "o", "<CR>" },
									action = "edit_in_place",
								},
								-- NOTE: override the "split" to avoid treating nvim-tree
								-- window as special. Splits will appear as if nvim-tree was a
								-- regular window
								{
									key = "<C-v>",
									action = "split_right",
									action_cb = function(node)
										vim.cmd("vsplit " .. vim.fn.fnameescape(node.absolute_path))
									end,
								},
								{
									key = "<C-x>",
									action = "split_bottom",
									action_cb = function(node)
										vim.cmd("split " .. vim.fn.fnameescape(node.absolute_path))
									end,
								},
								-- NOTE: override the "open in new tab" mapping to fix the error
								-- that occurs there
								{
									key = "<C-t>",
									action = "new_tab",
									action_cb = function(node)
										vim.cmd("tabnew " .. vim.fn.fnameescape(node.absolute_path))
									end,
								},
							},
						},
					},
					renderer = {
						group_empty = true,
						highlight_git = true,
					},
					actions = {
						change_dir = {
							-- NOTE: netrw-style, do not change the cwd when navigating
							enable = false,
						},
						open_file = {
							-- NOTE: prevent nvim-tree from re-appearing after opening a new window
							-- (changes the way autocommands are registered)
							quit_on_open = true,
						},
					},
				})
				-- NOTE: disable fixed nvim-tree width and height
				-- to allow creating splits naturally
				local winopts = require("nvim-tree.view").View.winopts
				winopts.winfixwidth = false
				winopts.winfixheight = false

				require("which-key").register({
					["-"] = {
						require("nvim-tree").open_replacing_current_buffer,
						"NvimTree in place",
					},
				})
			end,
		})

		use({
			"tpope/vim-vinegar",
			config = function()
				vim.g.netrw_banner = 0
				-- NOTE: enable number and relativenumber (disabled by default)
				vim.g.netrw_bufsettings = "noma nomod nobl nowrap ro number relativenumber"
			end,
			disable = true,
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
				---Use global status line instead of per-window status lines
				local global_status = false

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
				-- NOTE: the default nvim-tree extension is based on cwd
				-- netrw-mode does not change cwd
				local nvim_tree_extension = {
					sections = {
						lualine_a = {
							function()
								return vim.fn.fnamemodify(TreeExplorer.cwd, ":~")
							end,
						},
					},
					filetypes = {
						"NvimTree",
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
						local win_width = global_status and vim.go.columns or vim.fn.winwidth(0)
						if hide_width and win_width < hide_width then
							return ""
						elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
							return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
						end
						return str
					end
				end

				require("lualine").setup({
					options = {
						theme = "gruvbox-material",
						globalstatus = global_status,
					},
					sections = {
						lualine_a = { "mode" },
						lualine_b = { { "branch", fmt = trunc(150, 20, 120) } },
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
						lualine_y = { { "progress", fmt = trunc(nil, nil, 120) } },
						lualine_z = { "location" },
					},
					extensions = { "fugitive", nvim_tree_extension, "quickfix", dap_extension, "symbols-outline" },
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
		use("rhysd/conflict-marker.vim")
		use({
			"voldikss/vim-floaterm",
			config = function()
				require("which-key").register({
					["<Leader>G"] = {
						":FloatermNew --width=0.95 --height=0.95 lazygit<CR>",
						"lazygit in floating terminal",
					},
				})
			end,
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
			end,
		})

		use({
			"AckslD/nvim-trevJ.lua",
			config = function()
				local trevj = require("trevj")
				trevj.setup()
				require("which-key").register({
					["<Leader>J"] = { trevj.format_at_cursor, "Unjoin lines" },
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
					context_patterns = {
						-- NOTE: indent-blankline's defaults
						"class",
						"^func",
						"method",
						"^if",
						"while",
						"for",
						"with",
						"try",
						"except",
						"arguments",
						"argument_list",
						"object",
						"dictionary",
						"element",
						"table",
						"tuple",

						-- NOTE: better JavaScript/TypeScript support
						"return_statement",
						"statement_block",
					},

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
				}, {
					prefix = "<Leader>f",
				})

				require("telescope").setup({
					defaults = {
						-- NOTE: Lua regexps https://www.lua.org/manual/5.1/manual.html#5.4.1
						file_ignore_patterns = { "%.git/", "%.yarn/" },
						path_display = { ["truncate"] = 2 },
						mappings = {
							n = {
								dd = require("telescope.actions").delete_buffer,
							},
						},
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
				"williamboman/nvim-lsp-installer",
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
				vim.g.symbols_outline = {
					show_numbers = true,
					show_relative_numbers = true,
					preview_bg_highlight = "Normal",
				}
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
					ensure_installed = {
						"bash",
						"bibtex",
						"c",
						"comment",
						"css",
						"dockerfile",
						"go",
						"gomod",
						"gowork",
						"graphql",
						"hjson",
						"http",
						"java",
						"javascript",
						"jsdoc",
						"json",
						"json5",
						"jsonc",
						"latex",
						"lua",
						"make",
						"markdown",
						"nix",
						"python",
						"regex",
						"rust",
						"scss",
						"svelte",
						"toml",
						"tsx",
						"typescript",
						"vim",
						"vue",
						"yaml",
					},
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
		use({
			"ziontee113/syntax-tree-surfer",
			config = function()
				local surfer = require("syntax-tree-surfer")
				local wk = require("which-key")

				wk.register({
					J = {
						function()
							surfer.surf("next", "visual")
						end,
						"Surf to next node",
					},
					K = {
						function()
							surfer.surf("prev", "visual")
						end,
						"Surf to previous node",
					},
					H = {
						function()
							surfer.surf("parent", "visual")
						end,
						"Surf to parent node",
					},
					L = {
						function()
							surfer.surf("child", "visual")
						end,
						"Surf to child node",
					},
					["<A-J>"] = {
						function()
							surfer.surf("next", "visual", true)
						end,
						"Replace with next node",
					},
					["<A-K>"] = {
						function()
							surfer.surf("prev", "visual", true)
						end,
						"Replace with previous node",
					},
				}, { mode = "x" })

				wk.register({
					["<A-J>"] = {
						function()
							surfer.move("n", false)
						end,
						"Replace with next node",
					},
					["<A-K>"] = {
						function()
							surfer.move("n", true)
						end,
						"Replace with previous node",
					},
				})
			end,
		})
		use({
			"mfussenegger/nvim-treehopper",
			config = function()
				local wk = require("which-key")
				local tsht = require("tsht")

				-- NOTE: selection is lost when the keymap is registered using
				-- which-key or using a Lua callback
				vim.api.nvim_set_keymap("v", "<Leader>s", ":lua require('tsht').nodes()<CR>", {
					noremap = true,
				})

				wk.register({
					["<Leader>s"] = { tsht.nodes, "Select treesitter node" },
				}, { mode = "o" })
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
			"j-hui/fidget.nvim",
			config = function()
				require("fidget").setup({})
			end,
		})

		use({
			"monaqa/dial.nvim",
			config = function()
				local ws = require("which-key")
				local dial_map = require("dial.map")
				local function apply(fn)
					return function()
						fn()
					end
				end

				ws.register({
					["<C-a>"] = { apply(dial_map.inc_normal) },
					["<C-x>"] = { apply(dial_map.dec_normal) },
				})
				ws.register({
					["<C-a>"] = { apply(dial_map.inc_visual) },
					["<C-x>"] = { apply(dial_map.dec_visual) },
					["g<C-a>"] = { apply(dial_map.inc_gvisual), "Increment sequential" },
					["g<C-x>"] = { apply(dial_map.dec_gvisual), "Decrement sequential" },
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
				local default_settings = {
					takeover = "never",
					priority = 0,
					cmdline = "neovim",
				}
				vim.g.firenvim_config = {
					localSettings = {
						["https://(github.com|gitlab.com|mattermost\\.).*"] = vim.tbl_extend("error", default_settings, {
							filename = "{hostname%32}_{pathname%32}_{selector%32}_{timestamp%32}.md",
						}),
						[".*"] = default_settings,
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

            au BufEnter mail.google.com_*.txt set filetype=markdown tw=80
          ]])
				end
			end,
		})
		use({
			"chentoast/marks.nvim",
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
				local create_command = vim.api.nvim_create_user_command
				local utils = require("utils")

				-- TODO: support adding logpoints and conditional breakpoints
				create_command("DapToggleBreakpoint", utils.execute_function_without_args(dap.toggle_breakpoint), {})
				create_command("DapContinue", utils.execute_function_without_args(dap.continue), {})
				create_command("DapStepOver", utils.execute_function_without_args(dap.step_over), {})
				create_command("DapStepInto", utils.execute_function_without_args(dap.step_into), {})
				create_command("DapStepOut", utils.execute_function_without_args(dap.step_out), {})
				create_command("DapTerminate", utils.execute_function_without_args(dap.terminate), {})
				create_command("DapRunToCursor", utils.execute_function_without_args(dap.run_to_cursor), {})
				create_command("DapReplOpen", utils.execute_function_without_args(dap.repl.open), {})
				create_command("DapReplToggle", utils.execute_function_without_args(dap.repl.toggle), {})
				create_command("DapReplClose", utils.execute_function_without_args(dap.repl.close), {})
				create_command("DapStatus", function()
					print(dap.status())
				end, {})
			end,
		})

		use({
			"rcarriga/nvim-dap-ui",
			config = function()
				local dapui = require("dapui")
				dapui.setup()

				local create_command = vim.api.nvim_create_user_command
				local utils = require("utils")

				create_command("DapUIOpen", utils.execute_function_without_args(dapui.open), {})
				create_command("DapUIClose", utils.execute_function_without_args(dapui.close), {})
				create_command("DapUI", utils.execute_function_without_args(dapui.toggle), {})
				create_command("DapUIEval", function(args)
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
