local M = {}

-- TODO:
-- 1. Diff the contents of nvimrc files against already approved files
--
--    Store the approved files in stdpath('cache')/auto-nvimrc
--
-- 2. If there are differences, ask the user to confirm execution
--
--    a. accept once
--    b. accept always
--    c. deny once
--    d. deny always
--    e. review the diff (optional)
--
--  Maybe use nui.nvim for choices? Or inputlist()
--  Use https://github.com/Egor-Skriptunoff/pure_lua_SHA for hashing files
--
-- Use plenary.log for logging
-- https://github.com/nvim-lua/plenary.nvim/blob/master/lua/plenary/log.lua

local sha = require("auto-nvimrc.sha2")
local async = require("plenary.async")
local Path = require("plenary.path")

---Composes two functions
---@generic A
---@generic B
---@generic C
---@param f fun(b: B): C
---@param g fun(a: A): B
---@return fun(a: A): C
local function compose(f, g)
	return function(x)
		return f(g(x))
	end
end

---Reads contents of a file.
---@param file_path "Path": A plenary Path
---@return string "file contents"
local function read_file(file_path)
	return async.wrap(Path.read, 2)(file_path)
end

local get_file_hash = compose(sha.sha256, read_file)

---@generic T
---@param tbl T[]
---@return T "the first element of the table"
local function head(tbl)
	return tbl[1]
end

---Useful when using vim.tbl_map with joining
local function defer_call(fn)
	return function(arg)
		return function()
			return fn(arg)
		end
	end
end

---@param file_paths string[]
---@return string[]
local function get_file_hashes(file_paths)
	local wrapped_hashes = async.util.join(vim.tbl_map(defer_call(compose(get_file_hash, Path.new)), file_paths))

	return vim.tbl_map(head, wrapped_hashes)
end

local function run(nvimrcs_absolute_paths)
	local config_path = Path.new(vim.fn.stdpath("data"), "auto-nvimrc", "config.json")
	config_path:touch({ parents = true })

	async.run(function()
		local config_contents = read_file(config_path)
		print("contents", config_contents)
		async.util.scheduler()
		print(vim.inspect(vim.fn.json_decode(config_contents)))
		local hashes = get_file_hashes(nvimrcs_absolute_paths)
		local new_config = {}

		for i, hash in ipairs(hashes) do
			new_config[nvimrcs_absolute_paths[i]] = hash
		end

		async.util.scheduler()
		local serialized_config = vim.fn.json_encode(new_config)
		print(serialized_config)
		config_path:write(serialized_config, "w")

		return hashes
	end, function(hashes)
		print("got hashes", vim.inspect(hashes))
	end)
end

function M.execute_nvimrcs()
	local nvimrcs = vim.fn.findfile(".nvimrc", ".;", -1)

	if vim.tbl_isempty(nvimrcs) then
		return
	end

	local nvimrcs_absolute_paths = vim.tbl_map(function(path)
		return vim.fn.fnamemodify(path, ":p")
	end, nvimrcs)

	run(nvimrcs_absolute_paths)

	-- Loop from outermost (least specific) to innermost (most specific)
	for i = #nvimrcs, 1, -1 do
		local absolute_path = vim.fn.fnamemodify(nvimrcs[i], ":p")

		print("Source " .. absolute_path .. "? [y]/n: ")
		local choice = vim.fn.getcharstr()
		if string.lower(choice) ~= "n" then
			print("Sourcing " .. absolute_path)
			vim.cmd("source " .. absolute_path)
		end
	end
end

return M
