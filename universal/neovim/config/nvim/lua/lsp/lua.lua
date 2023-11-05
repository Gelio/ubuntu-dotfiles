local M = {}

local function get_all_lazy_plugin_lua_dirs()
	local plugins = {}
	local lazy_plugins_dir_path = vim.env.HOME .. "/.local/share/nvim/lazy"

	for name, type in vim.fs.dir(lazy_plugins_dir_path) do
		if type == "directory" then
			table.insert(plugins, vim.fs.joinpath(lazy_plugins_dir_path, name, "lua"))
		end
	end

	return plugins
end

M.config = vim.tbl_extend("error", require("lsp.utils").base_config_without_formatting, {
	on_init = function(client)
		local plugins = get_all_lazy_plugin_lua_dirs()

		client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
			Lua = {
				runtime = {
					version = "LuaJIT",
					path = {
						"?.lua",
						"?/init.lua",
						"lua/?.lua",
						"lua/?/init.lua",
					},
					pathStrict = true,
				},
				workspace = {
					library = vim.list_extend(plugins, {
						vim.env.VIMRUNTIME,
					}),
					checkThirdParty = false,
				},
				telemetry = {
					enable = false,
				},
			},
		})

		client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
	end,
})

return M
