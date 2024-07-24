return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
		},
		cmd = { "Telescope", "TelescopeHiddenFiles" },
		keys = {
			{ "<Leader>ff", "<cmd>Telescope find_files hidden=true<CR>", desc = "Files (Telescope)" },
			{ "<Leader>fg", "<cmd>TelescopeHiddenFiles<CR>", desc = "Files (Telescope)" },
			{ "<Leader>fGs", "<cmd>Telescope git_status<CR>", desc = "Git status (Telescope)" },
			{ "<Leader>fGf", "<cmd>Telescope git_files<CR>", desc = "Git files (Telescope)" },
			{ "<Leader>fGb", "<cmd>Telescope git_branches<CR>", desc = "Git branches (Telescope)" },
			{ "<Leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers (Telescope)" },
			{ "<Leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags (Telescope)" },
			{ "<Leader>fm", "<cmd>Telescope marks<CR>", desc = "Marks (Telescope)" },
			{ "<Leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "Old files (Telescope)" },
			{ "<Leader>fr", "<cmd>Telescope lsp_references<CR>", desc = "LSP references (Telescope)" },
			{
				"<Leader>fs",
				"<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
				desc = "LSP workspace symbols (Telescope)",
			},
		},
		init = function()
			require("which-key").add({
				{ "<Leader>f", group = "Find (Telescope)" },
			})
		end,
		opts = function()
			local vimgrep_args_hidden_files = require("telescope.config").set_defaults().get("vimgrep_arguments")
			table.insert(vimgrep_args_hidden_files, "--hidden")

			vim.api.nvim_create_user_command("TelescopeHiddenFiles", function()
				require("telescope").extensions.live_grep_args.live_grep_args({
					vimgrep_arguments = vimgrep_args_hidden_files,
				})
			end, {
				desc = "Grep files (including hidden) with Telescope",
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
}
