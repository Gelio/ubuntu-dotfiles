return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"romgrk/nvim-treesitter-context",
			"RRethy/nvim-treesitter-textsubjects",
			"windwp/nvim-ts-autotag",
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
					"prisma",
					"python",
					"query",
					"regex",
					"rust",
					"scss",
					"ssh_config",
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
				textsubjects = {
					enable = true,
					prev_selection = "<Leader>.",
					keymaps = {
						["."] = "textsubjects-smart",
					},
				},
				query_linter = {
					enable = true,
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
			})
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	{
		"ziontee113/syntax-tree-surfer",
		dependencies = { "nvim-treesitter" },
		keys = {
			{ "J", "<cmd>STSSelectNextSiblingNode<CR>", mode = "x", desc = "Surf to next node" },
			{ "K", "<cmd>STSSelectPrevSiblingNode<CR>", mode = "x", desc = "Surf to previous node" },
			{ "H", "<cmd>STSSelectParentNode<CR>", mode = "x", desc = "Surf to parent node" },
			{ "L", "<cmd>STSSelectChildNode<CR>", mode = "x", desc = "Surf to child node" },
			{ "<A-J>", "<cmd>STSSwapNextVisual<CR>", mode = "x", desc = "Replace with next node" },
			{ "<A-K>", "<cmd>STSSwapPrevVisual<CR>", mode = "x", desc = "Replace with previous node" },
			{ "<A-J>", "<cmd>STSSwapCurrentNodeNextNormal<CR>", mode = "n", desc = "Replace with next node" },
			{ "<A-K>", "<cmd>STSSwapCurrentNodePrevNormal<CR>", mode = "n", desc = "Replace with previous node" },
		},
		config = true,
	},
	{
		"mfussenegger/nvim-treehopper",
		keys = {
			{
				"<Leader>sn",
				":<C-U>lua require('tsht').nodes()<CR>",
				mode = { "x", "o" },
				desc = "Select treesitter node",
			},
		},
	},
	{
		"https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")

			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				highlight = {
					"RainbowLevel0",
					"RainbowLevel1",
					"RainbowLevel2",
					"RainbowLevel3",
					"RainbowLevel4",
					"RainbowLevel5",
					"RainbowLevel6",
					"RainbowLevel7",
				},
			}
		end,
	},
}
