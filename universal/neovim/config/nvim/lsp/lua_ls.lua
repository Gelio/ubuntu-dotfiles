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

local settings = {
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
		telemetry = {
			enable = false,
		},
	},
}

local function set_plugin_dirs_in_settings()
	local plugins = get_all_lazy_plugin_lua_dirs()

	settings.Lua.workspace = vim.tbl_deep_extend("force", settings.Lua.workspace or {}, {
		library = vim.list_extend(plugins, {
			vim.env.VIMRUNTIME,
		}),
		checkThirdParty = false,
	})
end

return {
	settings = settings,
	-- NOTE: read the list of plugins lazily,
	-- so we don't incur this cost on each nvim startup
	before_init = set_plugin_dirs_in_settings,
}
