-- NOTE: setting the options synchronously does not override Packer's default
-- options. Thus, we use `vim.schedule` to wait for a tick of the event loop to
-- defer setting the options. This takes precedence over Packer.
vim.schedule(function()
	vim.wo.number = true
	vim.wo.relativenumber = true
end)
