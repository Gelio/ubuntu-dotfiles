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
				vim.g.xremap = vim.g.nremap
			end,
		})
		use({
			"echasnovski/mini.trailspace",
			config = function()
				require("mini.trailspace").setup({})
			end,
		})
		use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })
		use({ "lewis6991/impatient.nvim" })

		use({
			-- NOTE: technically this plugin is not needed after https://github.com/neovim/neovim/pull/20936
			-- I still keep it around for now.
			"ojroques/nvim-osc52",
			config = function()
				vim.api.nvim_create_autocmd("TextYankPost", {
					group = vim.api.nvim_create_augroup("OSCYank", {}),
					desc = 'Use OSC52 to copy text from the "+ buffer from Neovim inside SSH',
					callback = function()
						if vim.v.event.operator == "y" and vim.v.event.regname == "+" then
							require("osc52").copy_register("+")
						end
					end,
				})
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
			"nvim-tree/nvim-web-devicons",
			config = function()
				require("nvim-web-devicons").setup({
					default = true,
				})
			end,
		})

		use({
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v2.x",
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",
				"MunifTanjim/nui.nvim",
			},
			setup = function()
				vim.g.neo_tree_remove_legacy_commands = 1
			end,
			config = function()
				require("which-key").register({
					["-"] = {
						function()
							local directory = vim.fn.expand("%:p:h")

							require("neo-tree.command").execute({
								action = "show",
								source = "filesystem",
								reveal = true,
								-- NOTE: prevent annoying "File not in cwd" prompts.
								-- Always use file's parent directory as neo-tree's cwd
								reveal_force_cwd = true,
								dir = directory,
								position = "current",
							})
						end,
						"Open parent directory in neo-tree",
					},
					["<leader>-"] = {
						":Neotree reveal dir=. position=current<CR>",
						"Open cwd in neo-tree",
					},
				})

				local events = require("neo-tree.events")
				---@class FileMovedArgs
				---@field source string
				---@field destination string

				---@param args FileMovedArgs
				local function on_file_remove(args)
					local ts_clients = vim.lsp.get_active_clients({ name = "tsserver" })
					for _, ts_client in ipairs(ts_clients) do
						ts_client.request("workspace/executeCommand", {
							command = "_typescript.applyRenameFile",
							arguments = {
								{
									sourceUri = vim.uri_from_fname(args.source),
									targetUri = vim.uri_from_fname(args.destination),
								},
							},
						})
					end
				end

				require("neo-tree").setup({
					use_popups_for_input = false,
					window = {
						position = "current",
						mappings = {
							o = "open",
							a = {
								"add",
								config = {
									show_path = "absolute",
								},
							},
							m = {
								"move",
								config = {
									show_path = "absolute",
								},
							},
						},
					},
					filesystem = {
						bind_to_cwd = false,
						window = {
							mappings = {
								["-"] = "navigate_up",
							},
						},
						hijack_netrw_behavior = "open_current",
					},
					nesting_rules = {
						ts = { "test.ts" },
					},
					event_handlers = {
						{
							event = events.NEO_TREE_BUFFER_ENTER,
							handler = function()
								vim.wo.number = true
								vim.wo.relativenumber = true
							end,
						},
						{
							event = events.FILE_MOVED,
							handler = on_file_remove,
						},
						{
							event = events.FILE_RENAMED,
							handler = on_file_remove,
						},
					},
				})
			end,
		})

		use({
			"miversen33/netman.nvim",
			config = function()
				require("netman")
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
			requires = { "nvim-tree/nvim-web-devicons" },
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
				--- Source: https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#truncating-components-in-smaller-window
				--- @param trunc_width? number trunctates component when screen width is less than trunc_width
				--- @param trunc_len? number truncates component to trunc_len number of chars
				--- @param hide_width? number hides component when window width is smaller then hide_width
				--- @param no_ellipsis? boolean whether to disable adding '...' at end after truncation
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
							},
							{ "encoding", fmt = trunc(nil, nil, 150) },
							{ "fileformat", fmt = trunc(nil, nil, 150) },
							{ "filetype", fmt = trunc(150, 8) },
						},
						lualine_y = { { "progress", fmt = trunc(nil, nil, 120) } },
						lualine_z = { "location" },
					},
					extensions = { "fugitive", "quickfix", dap_extension, "symbols-outline", "neo-tree" },
				})
			end,
		})

		use({
			"alvarosevilla95/luatab.nvim",
			requires = "nvim-tree/nvim-web-devicons",
			config = function()
				require("luatab").setup({})
			end,
		})

		use("tpope/vim-fugitive")
		use("tpope/vim-rhubarb")
		use("shumphrey/fugitive-gitlab.vim")
		use("junegunn/gv.vim")
		use({
			"akinsho/git-conflict.nvim",
			-- NOTE: use stable releases.
			-- This also fixes a bug which causes git-conflict.nvim only work when
			-- neovim is opened in the root of the repository.
			tag = "*",
			config = function()
				require("git-conflict").setup({
					highlights = {
						-- NOTE: the default `current` highlight color is too heavy
						current = "DiffChange",
					},
				})
			end,
			-- NOTE: gruvbox-material resets highlights during its initialization.
			-- git-conflict relies on its highlights to correctly highlight hunks
			after = { "gruvbox-material" },
		})
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
					keywords = {
						SAFETY = { color = "hint", icon = "" },
					},
				})
			end,
		})
		use({
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup({
					pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
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
				require("headlines").setup({
					markdown = {
						fat_headlines = false,
					},
				})
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
			"Gelio/wilder.nvim",
			branch = "fix-last-arg-completion-for-lua",
			config = function()
				vim.cmd.runtime("wilder.vim")

				vim.cmd.call("wilder#main#start()")
			end,
			run = ":UpdateRemotePlugins",
			event = "CmdlineEnter",
		})

		-- Telescope
		use({
			"nvim-telescope/telescope.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope-live-grep-args.nvim",
			},
			config = function()
				local vimgrep_args_hidden_files = require("telescope.config").set_defaults().get("vimgrep_arguments")
				table.insert(vimgrep_args_hidden_files, "--hidden")

				require("which-key").register({
					name = "Telescope",
					f = { "<cmd>Telescope find_files hidden=true<CR>", "Files" },
					g = {
						function()
							require("telescope").extensions.live_grep_args.live_grep_args({
								vimgrep_arguments = vimgrep_args_hidden_files,
							})
						end,
						"Grep with rg",
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
					m = { "<cmd>Telescope marks<CR>", "Marks" },
					o = { "<cmd>Telescope oldfiles<CR>", "Old files" },
					r = { "<cmd>Telescope lsp_references<CR>", "LSP references" },
					s = { "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "LSP workspace symbols" },
				}, {
					prefix = "<Leader>f",
				})

				local lga_actions = require("telescope-live-grep-args.actions")
				require("telescope").setup({
					extensions = {
						live_grep_args = {
							mappings = {
								i = {
									["<C-k>"] = lga_actions.quote_prompt(),
								},
							},
						},
					},
					defaults = {
						-- NOTE: Lua regexps https://www.lua.org/manual/5.1/manual.html#5.4.1
						file_ignore_patterns = { "%.git/", "%.yarn/", "%.next/" },
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

				require("mason").setup()
				require("mason-lspconfig").setup()
				require("lsp")
				require("dim").setup({})
			end,
			requires = {
				"jose-elias-alvarez/typescript.nvim",
				"jose-elias-alvarez/null-ls.nvim",
				"mfussenegger/nvim-jdtls",
				"b0o/SchemaStore.nvim",
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				"narutoxy/dim.lua",
			},
		})

		use({
			"simrat39/symbols-outline.nvim",
			config = function()
				require("which-key").register({ ["<Leader>so"] = { ":SymbolsOutline<CR>", "Symbols outline" } })
				require("symbols-outline").setup({
					show_numbers = true,
					show_relative_numbers = true,
				})
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
						{ name = "luasnip" },
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
			requires = {
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
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
			},
		})
		use({
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
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					desc = "Show lightbulb in the signcolumn whenever an LSP action is available",
					group = vim.api.nvim_create_augroup("LspLightBulb", {}),
					callback = require("nvim-lightbulb").update_lightbulb,
					pattern = "*",
				})
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
				require("nvim-treesitter.configs").setup({
					ensure_installed = {
						"bash",
						"bibtex",
						"c",
						"comment",
						"css",
						"diff",
						"dockerfile",
						"git_rebase",
						"gitattributes",
						"gitcommit",
						"gitignore",
						"go",
						"gomod",
						"gowork",
						"graphql",
						"hcl",
						"hjson",
						"http",
						"ini",
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
						"markdown_inline",
						"nix",
						"python",
						"query",
						"regex",
						"rust",
						"scss",
						"svelte",
						"terraform",
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
					playground = {
						enable = true,
					},
					query_linter = {
						enable = true,
					},
					textobjects = {
						swap = {
							enable = true,
							swap_next = {
								["]a"] = { "@parameter.inner" },
							},
							swap_previous = {
								["[a"] = { "@parameter.inner" },
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
			"kevinhwang91/nvim-ufo",
			requires = "kevinhwang91/promise-async",
			config = function()
				vim.o.foldlevel = 99
				vim.o.foldenable = true

				require("ufo").setup()
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

		use({
			"kylechui/nvim-surround",
			config = function()
				require("nvim-surround").setup({})
			end,
		})

		use({
			"stevearc/dressing.nvim",
			config = function()
				require("dressing").setup({
					input = {
						-- NOTE: the input is usually too small to handle file paths in nvim-tree
						-- and it does not support C-f to edit the value in a new window
						enabled = false,
					},
				})
			end,
		})
		use({
			"ziontee113/icon-picker.nvim",
			config = function()
				require("icon-picker")

				vim.keymap.set(
					"i",
					-- Requires special terminal configuration to work
					-- @see https://github.com/ziontee113/yt-tutorials/tree/nvim_key_combos_in_alacritty_and_kitty
					"<C-i>",
					"<cmd>PickIconsInsert<CR>",
					{ noremap = true, silent = true }
				)
			end,
		})

		use("aklt/plantuml-syntax")
		use({ "Gelio/auto-nvimrc" })
		use({ "ekalinin/dockerfile.vim" })
		use({
			"vuki656/package-info.nvim",
			requires = { "MunifTanjim/nui.nvim" },
			config = function()
				require("package-info").setup()

				local package_info_augroup = vim.api.nvim_create_augroup("PackageInfoMappings", {})
				vim.api.nvim_create_autocmd("BufEnter", {
					pattern = "package.json",
					callback = function()
						require("which-key").register({
							pd = { "<cmd>lua require('package-info').delete()<CR>", "Delete package" },
							pc = { "<cmd>lua require('package-info').change_version()<CR>", "Install another version" },
						}, {
							prefix = "<Leader>",
							buffer = vim.fn.bufnr(),
						})
					end,
					group = package_info_augroup,
				})
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
			"nvim-lua/plenary.nvim",
			config = function()
				local group_id = vim.api.nvim_create_augroup("PlenaryTests", {})
				vim.api.nvim_create_autocmd("BufEnter", {
					pattern = { "*/tests/*_spec.lua", "*/test/*_spec.lua" },
					group = group_id,
					callback = function()
						vim.keymap.set("n", "<Leader>te", "<Plug>PlenaryTestFile", { buffer = 0, remap = true })
					end,
				})
			end,
		})

		use({
			"petertriho/nvim-scrollbar",
			config = function()
				require("scrollbar").setup({
					handle = {
						highlight = "Visual",
					},
					marks = {
						Search = { highlight = "Orange" },
						Error = { highlight = "VirtualTextError" },
						Warn = { highlight = "VirtualTextWarning" },
						Info = { highlight = "VirtualTextInfo" },
						Hint = { highlight = "VirtualTextHint" },
						Misc = { highlight = "Purple" },
					},
					handlers = {
						gitsigns = true,
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

				ws.register({
					["<C-a>"] = { dial_map.inc_normal(), "Increment" },
					["<C-x>"] = { dial_map.dec_normal(), "Decrement" },
				})
				ws.register({
					["<C-a>"] = { dial_map.inc_visual(), "Increment" },
					["<C-x>"] = { dial_map.dec_visual(), "Decrement" },
					["g<C-a>"] = { dial_map.inc_gvisual(), "Increment by count" },
					["g<C-x>"] = { dial_map.dec_gvisual(), "Decrement by count" },
				}, { mode = "v" })
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
					local group_id = vim.api.nvim_create_augroup("FirenvimConfig", {})

					vim.api.nvim_create_autocmd("BufEnter", {
						pattern = "mail.google.com_*.txt",
						group = group_id,
						callback = function()
							vim.bo.filetype = "markdown"
							vim.o.textwidth = 80
						end,
					})

					vim.api.nvim_create_autocmd("UIEnter", {
						group = group_id,
						callback = function()
							vim.o.cmdheight = 1

							local min_lines = 18
							if vim.o.lines < min_lines then
								vim.o.lines = min_lines
							end

							vim.o.wrap = true
							vim.o.linebreak = true

							-- TODO: disable textwidth rule for markdownlint
						end,
					})
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
			"AckslD/nvim-FeMaco.lua",
			config = function()
				require("femaco").setup()
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