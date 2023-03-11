return {
	{ "tpope/vim-repeat" },
	{ "wellle/targets.vim" },
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
		"bkad/camelcasemotion",
		init = function()
			vim.g.camelcasemotion_key = "<Leader>"
		end,
	},
	{
		"junegunn/vim-easy-align",
		keys = {
			{ "ga", "<Plug>(EasyAlign)", mode = { "n", "x" } },
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
			{ "s", mode = { "n", "x" } },
			{ "S", mode = { "n", "x" } },
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
		config = function()
			require("telescope").load_extension("refactoring")
		end,
	},
	{
		"kylechui/nvim-surround",
		keys = {
			"ys",
			"ds",
			"cs",
		},
		config = true,
	},

	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async", "nvim-treesitter" },
		init = function()
			vim.o.foldlevel = 99
			vim.o.foldenable = true
		end,
		event = { "BufReadPost", "BufNewFile" },
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
		"chentoast/marks.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = true,
	},
}
