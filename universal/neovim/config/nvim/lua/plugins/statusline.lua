return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		opts = function()
			---Use global status line instead of per-window status lines
			local global_status = false

			local dap_extension = {
				sections = {
					lualine_a = { "mode", "filename" },
				},
				inactive_sections = {
					lualine_a = { "filename" },
				},
				filetypes = {
					"dapui_scopes",
					"dapui_watches",
					"dapui_stacks",
					"dapui_breakpoints",
					"dap-repl",
				},
			}
			--- Source: https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#truncating-components-in-smaller-window
			--- @param trunc_width? number trunctates component when screen width is less than trunc_width
			--- @param trunc_len? number truncates component to trunc_len number of chars
			--- @param hide_width? number hides component when window width is smaller then hide_width
			--- @param no_ellipsis? boolean whether to disable adding '...' at end after truncation
			--- return function that can format the component accordingly
			local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
				return function(str)
					local win_width = global_status and vim.go.columns or vim.fn.winwidth(0)
					if hide_width and win_width < hide_width then
						return ""
					elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
						return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
					end
					return str
				end
			end

			return {
				options = {
					theme = "gruvbox-material",
					globalstatus = global_status,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						{ "branch", fmt = trunc(150, 20, 120) },
						{
							"diff",
							source = function()
								local gitsigns_stats = vim.b.gitsigns_status_dict
								if not gitsigns_stats then
									return {}
								end
								return {
									added = gitsigns_stats.added,
									modified = gitsigns_stats.changed,
									removed = gitsigns_stats.removed,
								}
							end,
						},
					},
					lualine_c = {
						{
							function()
								return require("arrow.statusline").text_for_statusline_with_icons()
							end,
							cond = function()
								local success = pcall(function()
									return require("arrow.statusline")
								end)
								return success
							end,
						},
						{
							"filename",
							path = 1, -- NOTE: show relative file path
						},
					},
					lualine_x = {
						{
							"diagnostics",
							sources = { "nvim_diagnostic" },
						},
						{ "encoding", fmt = trunc(nil, nil, 150) },
						{ "fileformat", fmt = trunc(nil, nil, 150) },
						{ "filetype", fmt = trunc(150, 8) },
					},
					lualine_y = { { "progress", fmt = trunc(nil, nil, 120) } },
					lualine_z = { "location" },
				},
				extensions = {
					"fugitive",
					"lazy",
					"man",
					"mason",
					"oil",
					"quickfix",
					"symbols-outline",
					"trouble",
					-- TODO: consider using the "nvim-dap-ui" extension
					dap_extension,
				},
			}
		end,
	},

	{
		"alvarosevilla95/luatab.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		event = "VeryLazy",
		config = true,
	},
}
