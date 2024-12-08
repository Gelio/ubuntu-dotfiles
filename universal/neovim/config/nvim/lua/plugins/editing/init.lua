return {
	{ "tpope/vim-repeat" },
	{ "tpope/vim-abolish" },
	{ "wellle/targets.vim" },
	{
		"tpope/vim-unimpaired",
		init = function()
			-- NOTE: despite Neovim adding some vim-unimpaired-inspired mappings, I
			-- still need vim-unimpaired for:
			-- * [e, ]e (exchange lines)
			-- * [o, ]o (toggle options)
			-- * ]p, [p (paste linewise)

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
		"chrisgrieser/nvim-spider",
		keys = vim.tbl_map(function(key)
			return {
				string.format("<Leader>%s", key),
				string.format("<cmd>lua require('spider').motion('%s')<CR>", key),
				mode = { "n", "x", "o" },
			}
		end, { "w", "e", "b", "ge" }),
	},
	{
		"junegunn/vim-easy-align",
		keys = {
			{ "gA", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "Align" },
		},
	},
	{
		"altermo/ultimate-autopair.nvim",
		event = { "InsertEnter", "CmdlineEnter" },
		branch = "v0.6",
		opts = {},
	},
	{
		"ggandor/lightspeed.nvim",
		keys = {
			{ "s", mode = { "n", "x" } },
			{ "S", mode = "n" },
			{ "z", mode = "o" },
			{ "Z", mode = "o" },
			{ "x", mode = "o" },
			{ "X", mode = "o" },

			-- NOTE: for some reason, lightspeed does not set these 2 automatically
			{ "gs", "<Plug>Lightspeed_gs", mode = "n" },
			{ "gS", "<Plug>Lightspeed_gS", mode = "n" },

			{ "f", mode = { "n", "x", "o" } },
			{ "F", mode = { "n", "x", "o" } },
			{ "t", mode = { "n", "x", "o" } },
			{ "T", mode = { "n", "x", "o" } },
		},
	},
	{
		"echasnovski/mini.splitjoin",
		config = function()
			require("mini.splitjoin").setup({
				mappings = {
					toggle = "<Leader>J",
				},
			})
		end,
		keys = {
			{ "<Leader>J", desc = "Split/join region" },
		},
	},
	{
		"mbbill/undotree",
		keys = {
			{ "<Leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle undo tree" },
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
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		keys = {
			{
				"<Leader>rt",
				"<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
				mode = "v",
				desc = "Choose a refactor",
			},
		},
		cmd = "Refactor",
		config = function()
			require("refactoring").setup({})
			require("telescope").load_extension("refactoring")
		end,
	},
	{
		"kylechui/nvim-surround",
		keys = {
			"ys",
			"ds",
			"cs",
			{ "S", "<Plug>(nvim-surround-visual)", mode = { "x" } },
			{ "gS", "<Plug>(nvim-surround-visual-line)", mode = { "x" } },
		},
		config = true,
	},

	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async", "nvim-treesitter" },
		init = function()
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
		end,
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local ufo = require("ufo")

			vim.keymap.set("n", "zR", ufo.openAllFolds)
			vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds)
			vim.keymap.set("n", "zM", ufo.closeAllFolds)
			vim.keymap.set("n", "zm", ufo.closeFoldsWith)

			ufo.setup()
		end,
	},

	{
		"monaqa/dial.nvim",
		keys = {
			{ "<C-a>", "<Plug>(dial-increment)", mode = { "n", "v" }, desc = "Increment" },
			{ "<C-x>", "<Plug>(dial-decrement)", mode = { "n", "v" }, desc = "Decrement" },
			{ "g<C-a>", "g<Plug>(dial-increment)", mode = "v", desc = "Increment by count", remap = true },
			{ "g<C-x>", "g<Plug>(dial-decrement)", mode = "v", desc = "Decrement by count", remap = true },
		},
		config = function()
			local augend = require("dial.augend")
			local dial_config = require("dial.config")

			dial_config.augends:register_group({
				default = vim.list_extend({
					augend.constant.alias.bool,
					augend.constant.new({
						elements = { "&&", "||" },
						word = false,
						cyclic = true,
					}),
				}, dial_config.augends:get("default")),
			})
		end,
	},

	{
		"chentoast/marks.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = true,
	},

	{
		"johmsalas/text-case.nvim",
		cmd = { "Subs" },
		keys = {
			{ "ga", mode = { "n", "v" }, desc = "Change text case" },
		},
		config = function()
			require("textcase").setup()
		end,
	},

	{
		"cshuaimin/ssr.nvim",
		keys = {
			{
				"<Leader>sr",
				"<cmd>SSR<CR>",
				mode = { "n", "x" },
				desc = "Structural search and replace",
			},
		},
		cmd = { "SSR" },
		config = function()
			local ssr = require("ssr")
			ssr.setup()

			vim.api.nvim_create_user_command("SSR", function()
				ssr.open()
			end, {
				desc = "Structural search and replace",
				range = true,
			})
		end,
	},

	{
		"chrisgrieser/nvim-various-textobjs",
		opts = {
			keymaps = { useDefaults = false },
		},
		keys = function()
			local mappings = {
				S = "subword",
				v = "value",
				k = "key",
			}

			local function get_mapping_rhs(textobj, inner)
				return string.format("<cmd>lua require('various-textobjs')['%s'](%s)<CR>", textobj, inner and "true" or "false")
			end

			---@type LazyKeysSpec[]
			local keys = {}
			for key, textobj in pairs(mappings) do
				table.insert(keys, {
					string.format("a%s", key),
					get_mapping_rhs(textobj, false),
					mode = { "o", "x" },
				})
				table.insert(keys, {
					string.format("i%s", key),
					get_mapping_rhs(textobj, true),
					mode = { "o", "x" },
				})
			end

			return keys
		end,
	},

	{
		"otavioschwanck/arrow.nvim",
		opts = {
			show_icons = true,
			always_show_path = true,
			leader_key = "<Leader>ar",
			mappings = {
				toggle = "t",
				open_vertical = "v",
				open_horizontal = "x", -- Matches Telescope
			},
		},
	},

	{
		"nvim-ts-autotag",
		event = "InsertEnter",
		config = true,
	},
}
