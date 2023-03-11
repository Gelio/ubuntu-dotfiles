return {
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
}
