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

function M.execute_nvimrcs()
	local nvimrcs = vim.fn.findfile(".nvimrc", ".;", -1)

	if vim.tbl_isempty(nvimrcs) then
		return
	end

	-- TODO: use plenary.path module for reading files

	-- Loop from outermost (least specific) to innermost (most specific)
	for i = #nvimrcs, 1, -1 do
		local full_path = vim.fn.fnamemodify(nvimrcs[i], ":p")

		print("Source " .. full_path .. "? [y]/n: ")
		local choice = vim.fn.getcharstr()
		if string.lower(choice) ~= "n" then
			print("Sourcing " .. full_path)
			vim.cmd("source " .. full_path)
		end
	end
end

return M
