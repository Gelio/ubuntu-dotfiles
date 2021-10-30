local M = {}

-- TODO:
-- 1. Add reviewing diffs when files are modified
--    Maybe use nui.nvim for choices? Or inputlist()
--    Use https://github.com/Egor-Skriptunoff/pure_lua_SHA for hashing files
--
-- 2. Use plenary.log for logging
--    https://github.com/nvim-lua/plenary.nvim/blob/master/lua/plenary/log.lua

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
local read_file = async.wrap(Path.read, 2)

local get_file_hash = compose(sha.sha256, read_file)

-- TODO:
-- 1. Use vim.json.decode and vim.json.encode (for performance gains)
-- 2. Operate on objects (use OOP instead of procedural programming)

---@alias nvimrc_exec_status '"always"' | '"always_until_modified"' | '"ask"' | '"never"' | '"never_until_modified"'

-- TODO: use this enum instead of using strings
---@type table<nvimrc_exec_status, nvimrc_exec_status>
local nvimrc_states = vim.tbl_add_reverse_lookup({
	"always",
	"always_until_modified",
	"ask",
	"never",
	"never_until_modified",
})

---@class NvimrcInfo
---@field hash string
---@field status nvimrc_exec_status

---@alias NvimrcConfig table<string, NvimrcInfo>

---@return "Path"
local function get_config_path()
	return Path.new(vim.fn.stdpath("data"), "auto-nvimrc", "config.json")
end

---@return NvimrcConfig
local function get_nvimrc_config()
	local config_path = get_config_path()
	-- NOTE: Creates config file and parent directories in case they do not exist
	config_path:touch({ parents = true })

	local contents = read_file(config_path)
	async.util.scheduler()

	if string.len(contents) == 0 then
		return {}
	else
		return vim.fn.json_decode(contents)
	end
end

---@alias ask_reason "new_file" | "exec_status_ask" | "modified"

-- @type table<ask_reason, string>
local human_readable_reasons = {
	new_file = "new",
	exec_status_ask = "known but should be asked again",
	modified = "modified",
}

---@class NvimrcExecutionAnswer
---@field should_execute boolean
---@field exec_status nvimrc_exec_status

---@type table<number, nvimrc_exec_status>
local choice_to_exec_status_mapping = {
	[1] = "always",
	[2] = "always_until_modified",
	[3] = "ask",
	[4] = "ask",
	[5] = "never",
	[6] = "never_until_modified",
}

---@param path "Path"
---@param ask_reason ask_reason
---@return NvimrcExecutionAnswer
local function ask_for_file_execution(path, ask_reason)
	async.util.scheduler()

	local human_readable_reason = human_readable_reasons[ask_reason]
	local choice = vim.fn.inputlist({
		"[auto-nvimrc] File " .. path:absolute() .. " is " .. human_readable_reason .. ". Execute?",
		"1. Yes, always",
		"2. Yes, always until changed",
		"3. Yes, but ask again next time",
		"4. No, but ask again next time (default)",
		"5. No, never",
		"6. No, never until changed",
	})
	print("\n")

	if choice == 0 then
		-- NOTE: default case
		choice = 4
	end

	return {
		should_execute = choice >= 1 and choice <= 3,
		exec_status = choice_to_exec_status_mapping[choice],
	}
end

---@class NvimrcProcessingResult
---@field path "Path"
---@field should_execute boolean
---@field new_info NvimrcInfo?

---Decides what to do about an nvimrc
---@param config NvimrcConfig
---@param nvimrc_path "Path"
---@return NvimrcProcessingResult[]
local function process_nvimrc_path(config, nvimrc_path)
	local nvimrc_info = config[nvimrc_path:absolute()]
	-- TODO: extract asking for file execution and preparing the `NvimrcProcessingResult`
	-- It is very siimlar in almost all cases
	if nvimrc_info == nil then
		-- NOTE: new file
		local hash = get_file_hash(nvimrc_path)
		local answer = ask_for_file_execution(nvimrc_path, "new_file")
		return {
			path = nvimrc_path,
			should_execute = answer.should_execute,
			new_info = {
				hash = hash,
				status = answer.exec_status,
			},
		}
	end

	if type(nvimrc_info) ~= "table" then
		error(
			"The config entry for "
				.. nvimrc_path:absolute()
				.. " is malformed. Check "
				.. get_config_path():absolute()
				.. " and remove the entry or fix it yourself if you know how"
		)
	end

	if nvimrc_info.status == "always" then
		return {
			path = nvimrc_path,
			should_execute = true,
		}
	elseif nvimrc_info.status == "always_until_modified" then
		do
			local hash = get_file_hash(nvimrc_path)
			if hash == nvimrc_info.hash then
				return {
					path = nvimrc_path,
					should_execute = true,
				}
			else
				-- NOTE: modified, ask
				local answer = ask_for_file_execution(nvimrc_path, "modified")
				return {
					path = nvimrc_path,
					should_execute = answer.should_execute,
					new_info = {
						hash = hash,
						status = answer.exec_status,
					},
				}
			end
		end
	elseif nvimrc_info.status == "ask" then
		-- NOTE: ask
		local hash = get_file_hash(nvimrc_path)
		local answer = ask_for_file_execution(nvimrc_path, "exec_status_ask")
		return {
			path = nvimrc_path,
			should_execute = answer.should_execute,
			new_info = {
				hash = hash,
				status = answer.exec_status,
			},
		}
	elseif nvimrc_info.status == "never" then
		return {
			path = nvimrc_path,
			should_execute = false,
		}
	elseif nvimrc_info.status == "never_until_modified" then
		do
			local hash = get_file_hash(nvimrc_path)
			if hash == nvimrc_info.hash then
				return {
					path = nvimrc_path,
					should_execute = false,
				}
			else
				-- modified, ask
				local answer = ask_for_file_execution(nvimrc_path, "modified")
				return {
					path = nvimrc_path,
					should_execute = answer.should_execute,
					new_info = {
						hash = hash,
						status = answer.exec_status,
					},
				}
			end
		end
	end
end

local function run(nvimrcs)
	---@type "Path[]"
	local nvimrcs_absolute_paths = vim.tbl_map(Path.new, nvimrcs)

	async.run(function()
		local config = get_nvimrc_config()

		---@type NvimrcProcessingResult[]
		local nvimrc_processing_results = vim.tbl_map(func.partial(process_nvimrc_path, config), nvimrcs_absolute_paths)

		local config_modified = false

		async.util.scheduler()
		for _, result in ipairs(nvimrc_processing_results) do
			if result.should_execute then
				vim.cmd("source " .. result.path:absolute())
			end

			if result.new_info ~= nil then
				config[result.path:absolute()] = result.new_info
				config_modified = true
			end
		end

		if config_modified then
			local serialized_config = vim.fn.json_encode(config)
			get_config_path():write(serialized_config, "w")
		end

		return config
	end, function() end)
end

function M.execute_nvimrcs()
	local nvimrcs = vim.fn.findfile(".nvimrc", ".;", -1)

	if vim.tbl_isempty(nvimrcs) then
		return
	end

	run(nvimrcs)
end

return M
