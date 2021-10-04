local M = {}

-- TODO:
-- 1. Diff the contents of nvimrc files against already approved files
--
--    Store the approved files in stdpath('cache')/auto-nvimrc
--
-- 2. If there are differences, ask the user to confirm execution
--
--    a. accelt once
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
local fun_utils = require("plenary.fun")

local function read_file(file_path)
	-- TODO: improve error handling
	-- 438 = 0o444 (mode)
	local _err, fd = async.uv.fs_open(file_path, "r", 438)
	assert(not _err, _err)

	local _err, stat = async.uv.fs_fstat(fd)
	assert(not _err, _err)

	local _err, contents = async.uv.fs_read(fd, stat.size, 0)
	assert(not _err, _err)

	local _err = async.uv.fs_close(fd)
	assert(not _err, _err)

	return contents
end

local function get_file_hash(file_path)
	return sha.sha256(read_file(file_path))
end

local function head(tbl)
	return tbl[1]
end

local function get_file_hashes(file_paths)
	local wrapped_hashes = async.util.join(vim.tbl_map(function(path)
		return function()
			return get_file_hash(path)
		end
	end, file_paths))

	return vim.tbl_map(head, wrapped_hashes)
end

function M.execute_nvimrcs()
	local nvimrcs = vim.fn.findfile(".nvimrc", ".;", -1)

	if vim.tbl_isempty(nvimrcs) then
		return
	end

	local nvimrcs_absolute_paths = vim.tbl_map(function(path)
		return vim.fn.fnamemodify(path, ":p")
	end, nvimrcs)

	async.run(function()
		return get_file_hashes(nvimrcs_absolute_paths)
	end, function(hashes)
		print("got hashes", vim.inspect(hashes))
	end)

	-- TODO: use plenary.path module for reading files

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
