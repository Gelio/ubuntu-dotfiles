return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "main",
		dependencies = {
			-- "nvim-treesitter/nvim-treesitter-textobjects",
			-- "romgrk/nvim-treesitter-context",
		},
		config = function()
			require("nvim-treesitter").install({
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
				"luadoc",
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
				"styled",
				"svelte",
				"terraform",
				"tmux",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"vue",
				"yaml",
			})

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("TreesitterEnable", { clear = true }),
				callback = function()
					if vim.o.filetype == "bigfile" then
						return
					end

					-- Start treesitter for the current buffer, and ignore errors
					-- if there is no parser available.
					pcall(vim.treesitter.start)
				end,
			})

			-- 	textobjects = {
			-- 		swap = {
			-- 			enable = true,
			-- 			swap_next = {
			-- 				["]a"] = "@parameter.inner",
			-- 			},
			-- 			swap_previous = {
			-- 				["[a"] = "@parameter.inner",
			-- 			},
			-- 		},
			-- 		select = {
			-- 			enable = true,
			-- 			keymaps = {
			-- 				["af"] = "@function.outer",
			-- 				["if"] = "@function.inner",
			-- 				["ac"] = "@call.outer",
			-- 				["ic"] = "@call.inner",
			-- 			},
			-- 		},
			-- 	},
			-- })
		end,
	},
	{
		"ziontee113/syntax-tree-surfer",
		enabled = false,
		dependencies = { "nvim-treesitter" },
		keys = {
			{ "J", "<cmd>STSSelectNextSiblingNode<CR>", mode = "x", desc = "Surf to next node" },
			{ "K", "<cmd>STSSelectPrevSiblingNode<CR>", mode = "x", desc = "Surf to previous node" },
			{ "H", "<cmd>STSSelectParentNode<CR>", mode = "x", desc = "Surf to parent node" },
			{ "L", "<cmd>STSSelectChildNode<CR>", mode = "x", desc = "Surf to child node" },
			{ "<C-N>", "<cmd>STSSwapNextVisual<CR>", mode = "x", desc = "Replace with next node" },
			{ "<C-P>", "<cmd>STSSwapPrevVisual<CR>", mode = "x", desc = "Replace with previous node" },
			{ "<C-N>", "<cmd>STSSwapCurrentNodeNextNormal<CR>", mode = "n", desc = "Replace with next node" },
			{ "<C-P>", "<cmd>STSSwapCurrentNodePrevNormal<CR>", mode = "n", desc = "Replace with previous node" },
		},
		config = true,
	},
	{
		"mfussenegger/nvim-treehopper",
		enabled = false,
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
		enabled = false,
		-- NOTE: this plugin uses submodules only for development.
		-- Let's skip them to speed up the installation and update process.
		submodules = false,
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
			}
		end,
	},
}
