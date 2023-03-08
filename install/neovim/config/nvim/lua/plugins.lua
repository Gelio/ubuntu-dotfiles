return {
	-- TODO: split plugins into files
	"tpope/vim-sensible",
	"tpope/vim-repeat",
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		lazy = false,
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
	},
	"wellle/targets.vim",
	{
		"tpope/vim-unimpaired",
		init = function()
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
	},

	{
		"echasnovski/mini.trailspace",
		config = function()
			require("mini.trailspace").setup()
		end,
	},

	{
		"bkad/camelcasemotion",
		init = function()
			vim.g.camelcasemotion_key = "<Leader>"
		end,
	},
	{ "nvim-tree/nvim-web-devicons", opts = { default = true } },

	{
		"junegunn/vim-easy-align",
		keys = {
			{ "ga", "<Plug>(EasyAlign)", mode = { "n", "x" } },
		},
	},

	{
		"tweekmonster/startuptime.vim",
		cmd = "StartupTime",
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
			-- NOTE: load neo-tree when opening a directory with nvim from the cmdline
			-- @see https://github.com/LazyVim/LazyVim/blob/b1b5b461bf9d853d8472ee5b968471695118958b/lua/lazyvim/plugins/editor.lua#L31-L37
			if vim.fn.argc() == 1 then
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
		keys = {
			{
				"-",
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
				desc = "Open parent directory in Neo-tree",
			},
			{
				"<Leader>-",
				":Neotree reveal dir=. position=current<CR>",
				desc = "Open cwd in neo-tree",
			},
		},
		ft = "netrw",
		opts = function()
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

			return {
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
			}
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		opts = function()
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

			return {
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
			}
		end,
	},

	{
		"alvarosevilla95/luatab.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		event = "VeryLazy",
		config = true,
	},

	{
		"tpope/vim-fugitive",
		cmd = { "G", "GBrowse" },
		ft = "gitcommit",
		dependencies = {
			"tpope/vim-rhubarb",
			"shumphrey/fugitive-gitlab.vim",
		},
	},
	{ "junegunn/gv.vim", cmd = "GV", dependencies = { "tpope/vim-fugitive" } },
	{
		"akinsho/git-conflict.nvim",
		event = { "BufReadPre", "BufNewFile" },
		-- NOTE: use stable releases.
		-- This also fixes a bug which causes git-conflict.nvim only work when
		-- neovim is opened in the root of the repository.
		version = "*",
		opts = function()
			return {
				highlights = {
					-- NOTE: the default `current` highlight color is too heavy
					current = "DiffChange",
				},
			}
		end,
	},
	{
		"voldikss/vim-floaterm",
		cmd = "FloatermNew",
		keys = {
			{
				"<Leader>G",
				":FloatermNew --width=0.95 --height=0.95 lazygit<CR>",
				desc = "lazygit in floating terminal",
			},
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			disable_in_macro = true,
		},
	},
	{
		"ggandor/lightspeed.nvim",
		keys = {
			{ "s", mode = { "n", "x", "o" } },
			{ "S", mode = { "n", "x", "o" } },
			{ "gs", mode = { "n", "x", "o" } },
			{ "gS", mode = { "n", "x", "o" } },
			{ "f", mode = { "n", "x", "o" } },
			{ "F", mode = { "n", "x", "o" } },
			{ "t", mode = { "n", "x", "o" } },
			{ "T", mode = { "n", "x", "o" } },
		},
	},

	{
		-- TODO: consider using mini-splitjoin instead
		-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-splitjoin.md
		"AckslD/nvim-trevJ.lua",
		config = true,
		keys = {
			{
				"<Leader>J",
				function()
					require("trevj").format_at_cursor()
				end,
				desc = "Unjoin lines",
			},
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	{
		"mbbill/undotree",
		keys = {
			{ "<Leader>u", ":UndotreeToggle<CR>", desc = "Toggle undo tree" },
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local ws = require("which-key")
			ws.setup({
				operators = {
					-- TODO: maybe delete this
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

			-- TODO: maybe move these to keymaps file
			-- TODO: add keymaps to move code up/down (maybe copy it from LazyVim)
			ws.register({
				["cn"] = { "*``cgn", "Search and replace" },
				["cN"] = { "*``cgN", "Search and replace backwards" },
				J = { "mzJ`z", "Join lines" },
				["<Leader>y"] = "Yank to clipboard",
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			colors = {
				info = { "VirtualTextInfo" },
				default = { "Aqua" },
			},
			keywords = {
				SAFETY = { color = "hint", icon = "" },
			},
		},
	},
	{
		"numToStr/Comment.nvim",
		opts = function()
			return {
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			}
		end,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
	},
	{ "kevinhwang91/nvim-bqf", ft = "qf" },
	{ "tpope/vim-obsession" },
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
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
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	{
		"lukas-reineke/headlines.nvim",
		opts = function()
			return {
				markdown = {
					fat_headlines = false,
				},
			}
		end,
	},

	{
		"norcalli/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local gitsigns = require("gitsigns")
			gitsigns.setup({
				on_attach = function(bufnr)
					local function map(mode, l, r, desc)
						vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
					end
					map("n", "[c", ":Gitsigns prev_hunk<CR>", "Previous hunk")
					map("n", "]c", ":Gitsigns next_hunk<CR>", "Next hunk")

					map({ "n", "v" }, "<Leader>hs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
					map({ "n", "v" }, "<Leader>hr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
					map("n", "<Leader>htd", gitsigns.toggle_deleted, "Toggle deleted lines")
					map("n", "<Leader>htb", gitsigns.toggle_current_line_blame, "Toggle current line blame")
					map("n", "<Leader>hb", function()
						gitsigns.blame_line({ full = true })
					end, "Blame current line")
					map("n", "<Leader>hR", gitsigns.reset_buffer, "Reset changes in buffer")
					map("n", "<Leader>hp", gitsigns.preview_hunk, "Preview hunk")
					map("n", "<Leader>hu", gitsigns.undo_stage_hunk, "Unstage last hunk")
				end,
			})
		end,
	},
	{
		"Gelio/wilder.nvim",
		branch = "fix-last-arg-completion-for-lua",
		config = function()
			vim.cmd.runtime("wilder.vim")

			vim.cmd.call("wilder#main#start()")
		end,
		build = ":UpdateRemotePlugins",
		event = "CmdlineEnter",
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
		},
		opts = function()
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
			return {
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
			}
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- TODO: extract these options elsewhere
			vim.o.cmdheight = 2
			vim.opt.shortmess:append("c")

			require("lsp")
		end,
		dependencies = {
			"jose-elias-alvarez/typescript.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			"mfussenegger/nvim-jdtls",
			"b0o/SchemaStore.nvim",
			{ "williamboman/mason.nvim", config = true },
			{ "williamboman/mason-lspconfig.nvim", config = true },
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "narutoxy/dim.lua", config = true },
			"Gelio/auto-nvimrc",
			{ "ray-x/lsp_signature.nvim", config = true },
		},
	},

	{
		"simrat39/symbols-outline.nvim",
		keys = {
			{ "<Leader>so", ":SymbolsOutline<CR>", "Symbols outline" },
		},
		config = function()
			require("symbols-outline").setup({
				show_numbers = true,
				show_relative_numbers = true,
			})
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
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
				build = "make install_jsregexp",
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
	{
		"folke/trouble.nvim",
		cmd = { "Trouble", "TroubleToggle" },
		keys = {
			{ "<Leader>tx", ":TroubleToggle<CR>" },
			{ "<Leader>tw", ":TroubleToggle workspace_diagnostics<CR>", desc = "Workspace diagnostics (Trouble)" },
			{ "<Leader>td", ":TroubleToggle document_diagnostics<CR>", desc = "Document diagnostics (Trouble)" },
			{ "<Leader>tq", ":TroubleToggle quickfix<CR>", desc = "Quickfix list (Trouble)" },
			{ "gR", ":TroubleToggle lsp_references<CR>", desc = "LSP references (Trouble)" },
		},
	},
	{
		"kosayoda/nvim-lightbulb",
		event = "VeryLazy",
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
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
			{ "folke/which-key.nvim" },
		},
		keys = {
			{
				"<Leader>rt",
				"<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
				mode = "v",
				desc = "Choose a refactor",
			},
		},
		config = function()
			require("refactoring").setup()
			require("telescope").load_extension("refactoring")
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
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
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		init = function()
			vim.o.foldlevel = 99
			vim.o.foldenable = true
		end,
		event = { "BufReadPost", "BufNewFile" },
		config = true,
	},
	{
		"ziontee113/syntax-tree-surfer",
		dependencies = { "nvim-treesitter" },
		keys = {
			{ "J", ":STSSelectNextSiblingNode<CR>", mode = "x", desc = "Surf to next node" },
			{ "K", ":STSSelectPrevSiblingNode<CR>", mode = "x", desc = "Surf to previous node" },
			{ "H", ":STSSelectParentNode<CR>", mode = "x", desc = "Surf to parent node" },
			{ "L", ":STSSelectChildNode<CR>", mode = "x", desc = "Surf to child node" },
			{ "<A-J>", ":STSSwapNextVisual<CR>", mode = "x", desc = "Replace with next node" },
			{ "<A-K>", ":STSSwapPrevVisual<CR>", mode = "x", desc = "Replace with previous node" },
			{ "<A-J>", ":STSSwapCurrentNodeNextNormal<CR>", mode = "n", desc = "Replace with next node" },
			{ "<A-K>", ":STSSwapCurrentNodeNextNormal<CR>", mode = "n", desc = "Replace with previous node" },
		},
		config = true,
	},
	{
		"mfussenegger/nvim-treehopper",
		keys = {
			{
				"<Leader>s",
				function()
					require("tsht").nodes()
				end,
				mode = { "x", "o" },
				desc = "Select treesitter node",
			},
		},
	},

	{
		"kylechui/nvim-surround",
		config = true,
	},

	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {
			input = {
				-- NOTE: the input is usually too small to handle file paths in nvim-tree
				-- and it does not support C-f to edit the value in a new window
				enabled = false,
			},
		},
	},
	{
		"vuki656/package-info.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		event = "BufReadPre package.json",
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
	},

	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Diffview",
		config = true,
	},

	{
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
	},

	{
		"petertriho/nvim-scrollbar",
		event = { "BufReadPost", "BufNewFile" },
		opts = function()
			return {
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
			}
		end,
	},

	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		config = true,
	},
	{
		"monaqa/dial.nvim",
		keys = {
			{ "<C-a>", "<Plug>(dial-increment)", mode = { "n", "v" }, desc = "Increment" },
			{ "<C-x>", "<Plug>(dial-decrement)", mode = { "n", "v" }, desc = "Decrement" },
			{ "g<C-a>", "g<Plug>(dial-increment)", mode = "v", desc = "Increment by count", remap = true },
			{ "g<C-x>", "g<Plug>(dial-decrement)", mode = "v", desc = "Decrement by count", remap = true },
		},
	},
	{
		"sindrets/winshift.nvim",
		cmd = "WinShift",
		keys = {
			{ "<C-W>m", ":WinShift<CR>", "Window shift mode" },
			{ "<C-W><C-M>", ":WinShift<CR>", "Window shift mode" },
		},
		config = true,
	},
	{
		"glacambre/firenvim",
		build = function()
			vim.fn["firenvim#install"](0)
		end,
		conf = vim.g.started_by_firenvim,
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
		end,
	},
	{
		"chentoast/marks.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = true,
	},

	{
		"mfussenegger/nvim-dap",
		keys = {
			{ "<Leader>xb", ":DapToggleBreakpoint<CR>", name = "Toggle breakpoint" },
			{ "<Leader>xc", ":DapContinue<CR>", name = "Continue" },
			{ "<Leader>xso", ":DapStepOut<CR>", name = "Step out" },
			{ "<Leader>xsn", ":DapStepOver<CR>", name = "Step over" },
			{ "<Leader>xsi", ":DapStepInto<CR>", name = "Step into" },
			{ "<Leader>xsc", ":DapRunToCursor<CR>", name = "Run to cursor" },
		},
		cmd = { "DapToggleBreakpoint", "DapContinue" },
		config = function()
			require("which-key").register({
				name = "Dap (debug)",
			}, { prefix = "<Leader>x" })

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
	},
	{
		"rcarriga/nvim-dap-ui",
		keys = {
			{ "<Leader>xK", ":DapUIEval<CR>", desc = "Evaluate expression under cursor" },
			{ "<Leader>xx", ":DapUI<CR>", desc = "Toggle Dap UI" },
		},
		cmd = { "DapUIOpen", "DapUI", "DapUIEval" },
		dependencies = { "nvim-dap" },
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
		end,
	},

	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && yarn install",
		cmd = { "MarkdownPreview" },
		config = function()
			vim.g.mkdp_echo_preview_url = true
		end,
	},

	{
		"AckslD/nvim-FeMaco.lua",
		cmd = { "FeMaco" },
		config = function()
			require("femaco").setup()
		end,
	},

	{
		"plasticboy/vim-markdown",
		config = function()
			vim.g.vim_markdown_no_extensions_in_markdown = true
		end,
		ft = "markdown",
		dependencies = {
			"godlygeek/tabular",
		},
	},
	{
		"mzlogin/vim-markdown-toc",
		ft = "markdown",
	},
}
