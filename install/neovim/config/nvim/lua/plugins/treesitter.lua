return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/playground",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"romgrk/nvim-treesitter-context",
			"RRethy/nvim-treesitter-textsubjects",
			"HiPhish/nvim-ts-rainbow2",
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
					prev_selection = "<Leader>.",
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
					query = {
						"rainbow-parens",
						html = "rainbow-tags",
						javascript = "rainbow-parens-react",
					},
					hlgroups = {
						-- NOTE: use hlgroups from nvim-ts-rainbow since they are handled by gruvbox-material
						-- https://github.com/sainnhe/gruvbox-material/blob/984d4bb876cccfeada376e86ba5babae59da1cce/colors/gruvbox-material.vim#L1230
						"rainbowcol1",
						"rainbowcol2",
						"rainbowcol3",
						"rainbowcol4",
						"rainbowcol5",
						"rainbowcol6",
						"rainbowcol7",
					},
				},
			})
		end,
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
}
