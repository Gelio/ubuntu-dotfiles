return {
	{
		"glacambre/firenvim",
		build = function()
			vim.fn["firenvim#install"](0)
		end,
		conf = vim.g.started_by_firenvim,
		config = function()
			local default_settings = {
				takeover = "never",
				priority = 0,
				cmdline = "neovim",
			}
			vim.g.firenvim_config = {
				localSettings = {
					["https://(github.com|gitlab.com|mattermost\\.).*"] = vim.tbl_extend("error", default_settings, {
						filename = "{hostname%32}_{pathname%32}_{selector%32}_{timestamp%32}.md",
					}),
					[".*"] = default_settings,
				},
			}

			-- https://github.com/glacambre/firenvim#building-a-firenvim-specific-config
			local group_id = vim.api.nvim_create_augroup("FirenvimConfig", {})

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "mail.google.com_*.txt",
				group = group_id,
				callback = function()
					vim.bo.filetype = "markdown"
					vim.o.textwidth = 80
				end,
			})

			vim.api.nvim_create_autocmd("UIEnter", {
				group = group_id,
				callback = function()
					vim.o.cmdheight = 1

					local min_lines = 18
					if vim.o.lines < min_lines then
						vim.o.lines = min_lines
					end

					vim.o.wrap = true
					vim.o.linebreak = true

					-- TODO: disable textwidth rule for markdownlint
				end,
			})
		end,
	},
}
