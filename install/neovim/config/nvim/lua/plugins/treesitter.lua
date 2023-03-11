return {
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
}
