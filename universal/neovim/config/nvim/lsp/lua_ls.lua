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

return {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
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
				library = vim.list_extend(get_all_lazy_plugin_lua_dirs(), {
					vim.env.VIMRUNTIME,
				}),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
