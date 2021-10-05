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
local func = require("plenary.functional")

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

-- TODO:
-- 1. Use vim.json.decode and vim.json.encode (for performance gains)
-- 2. Operate on objects (use OOP instead of procedural programming)

---@alias nvimrc_exec_status '"always"' | '"always_until_modified"' | '"ask"' | '"never"' | '"never_until_modified"'

---@type table<nvimrc_exec_status, nvimrc_exec_status>
local nvimrc_states = vim.tbl_add_reverse_lookup({
	"always",
	"always_until_modified",
	"ask",
	"never",
	"never_until_modified",
})

---@param file_paths "Path[]"
---@return string[]
local function get_file_hashes(file_paths)
	local wrapped_hashes = async.util.join(vim.tbl_map(defer_call(get_file_hash), file_paths))

	return vim.tbl_map(head, wrapped_hashes)
end

---@class NvimrcInfo
---@field hash string
---@field status nvimrc_exec_status

---@alias NvimrcConfig table<string, NvimrcInfo>

---@param path "Path"
---@return NvimrcConfig
local function get_nvimrc_config_from_path(path)
	local contents = read_file(path)
	async.util.scheduler()

	if string.len(contents) == 0 then
		return {}
	else
		return vim.fn.json_decode(contents)
	end
end

---@type nvimrc_exec_status[]
local statuses_to_never_read = { "always", "never" }
---Checks if a given nvimrc file should be read.
---Files that are always ignored or always accepted
---should never be read.
---@param config NvimrcConfig
---@param path "Path"
local function should_read_file(config, path)
	local nvimrc_info = config[path:absolute()]
	if nvimrc_info == nil then
		return true
	end

	return not vim.tbl_contains(statuses_to_never_read, nvimrc_info.status)
end

---@alias ask_reason "new_file" | "exec_status_ask" | "modified"

---Decides what to do about an nvimrc file.
---@param config NvimrcConfig
---@param paths "Path[]"
---@param hashes string[]
---@returns table List of nvimrcs to ask whether to execute
local function get_files_to_ask(config, paths, hashes)
	local paths_to_ask = {}

	for i, path in ipairs(paths) do
		local nvimrc_info = config[path:absolute()]
		---@type ask_reason
		local reason

		if nvimrc_info == nil then
			reason = "new_file"
		elseif nvimrc_info.status == "ask" then
			reason = "exec_status_ask"
		else
			local hash = hashes[i]
			if nvimrc_info.hash ~= hash then
				reason = "modified"
			end
		end

		if reason ~= nil then
			table.insert(paths_to_ask, { path = path, reason = reason })
		end
	end

	return paths_to_ask
end

local function ask_for_files_execution(config, files_to_ask)
	async.util.scheduler()
	for _, file_to_ask in ipairs(files_to_ask) do
		local choice = vim.fn.inputlist({
			"File " .. file_to_ask.path:absolute() .. " is " .. file_to_ask.reason .. ". Execute?",
			"1. Yes, always",
			"2. Yes, always until changed",
			"3. Yes, but ask again next time",
			"4. No, but ask again next time",
			"5. No, never",
			"6. No, never until changed",
		})
		print("\n")
	end
end

local function run(nvimrcs)
	local nvimrcs_absolute_paths = vim.tbl_map(Path.new, nvimrcs)

	local config_path = Path.new(vim.fn.stdpath("data"), "auto-nvimrc", "config.json")
	-- NOTE: Creates config file and parent directories in case they do not exist
	config_path:touch({ parents = true })

	async.run(function()
		local config = get_nvimrc_config_from_path(config_path)
		local paths_to_load = vim.tbl_filter(func.partial(should_read_file, config), nvimrcs_absolute_paths)

		-- 3. Ask if files should be executed
		-- 4. Save the results
		local hashes = get_file_hashes(paths_to_load)
		local paths_to_ask = get_files_to_ask(config, paths_to_load, hashes)
		ask_for_files_execution(config, paths_to_ask)

		-- async.util.scheduler()
		-- local serialized_config = vim.fn.json_encode(new_config)
		-- print(serialized_config)
		-- config_path:write(serialized_config, "w")

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

	run(nvimrcs)

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
