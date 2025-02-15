return {
	{
		"folke/todo-comments.nvim",
		cmd = {
			"TodoTrouble",
			"TodoQuickFix",
			"TodoLocList",
			"TodoTelescope",
		},
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
		"folke/trouble.nvim",
		cmd = { "Trouble" },
		keys = {
			{ "<Leader>td", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics (Trouble)" },
			{ "<Leader>tD", "<cmd>Trouble diagnostics toggle<CR>", desc = "Workspace diagnostics (Trouble)" },
			{ "<Leader>ts", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Symbols (Trouble)" },
			{ "<Leader>tl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "Quickfix list (Trouble)" },
			{ "<Leader>tq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix list (Trouble)" },
		},
		init = function()
			require("which-key").add({
				{ "<Leader>t", group = "Trouble" },
			})
		end,
		opts = {},
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		main = "ibl",
		opts = function()
			local ecma_node_types = { "object", "array", "switch_statement" }
			local typescript_node_types = vim.list_extend({ "object_type" }, ecma_node_types)

			return {
				indent = {
					char = "▎",
					tab_char = "┊",
				},
				whitespace = {
					-- NOTE: alternating indentation highlight
					highlight = { "Normal", "StatusLine" },
				},
				scope = {
					highlight = "Blue",

					include = {
						node_type = {
							["*"] = { "return_statement" },
							lua = { "table_constructor", "else_statement" },
							ecma = ecma_node_types,
							javascript = ecma_node_types,
							typescript = typescript_node_types,
							tsx = typescript_node_types,
						},
					},
				},
			}
		end,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {},
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	},

	{
		"catgoose/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("colorizer").setup()
		end,
	},

	{
		"j-hui/fidget.nvim",
		event = { "BufReadPre", "BufNewFile" },
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
		"echasnovski/mini.trailspace",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("mini.trailspace").setup()
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			disable = {
				buftypes = { "nofile" },
			},
		},
	},

	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		opts = { default = true },
	},

	{
		"tzachar/highlight-undo.nvim",
		keys = { "u", "<C-r>", "p", "P" },
		config = true,
	},
	{
		"briangwaltney/paren-hint.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = true,
	},
	{
		"nvim-pack/nvim-spectre",
		config = true,
		cmd = "Spectre",
		keys = {
			{ "<Leader>spp", "<cmd>lua require('spectre').toggle()<CR>", desc = "Toggle Spectre" },
			{
				"<Leader>spw",
				"<cmd>lua require('spectre').open_visual({ select_word = true })<CR>",
				desc = "Search current word in Spectre",
			},
			{
				"<Leader>spw",
				"<cmd>lua require('spectre').open_visual()<CR>",
				desc = "Search current word in Spectre",
				mode = "v",
			},
		},
	},

	{
		"3rd/image.nvim",
		opts = {},
	},
}
