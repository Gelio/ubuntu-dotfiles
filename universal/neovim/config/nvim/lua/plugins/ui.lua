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
		cmd = { "Trouble", "TroubleToggle" },
		keys = {
			{ "<Leader>tx", "<cmd>TroubleToggle<CR>" },
			{ "<Leader>tw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Workspace diagnostics (Trouble)" },
			{ "<Leader>td", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "Document diagnostics (Trouble)" },
			{ "<Leader>tq", "<cmd>TroubleToggle quickfix<CR>", desc = "Quickfix list (Trouble)" },
			{ "gR", "<cmd>TroubleToggle lsp_references<CR>", desc = "LSP references (Trouble)" },
		},
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
		"lukas-reineke/headlines.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "markdown", "norg" },
		opts = {
			markdown = {
				fat_headlines = false,
			},
		},
	},

	{
		"norcalli/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("colorizer").setup()
		end,
	},

	{
		"petertriho/nvim-scrollbar",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "gitsigns.nvim" },
		opts = {
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
		},
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
		keys = { "u", "<C-r>" },
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
}
