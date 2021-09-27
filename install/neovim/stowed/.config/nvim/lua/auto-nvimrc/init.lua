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
--  Maybe use nui.nvim for choices?
--
-- Use plenary.log for logging
-- https://github.com/nvim-lua/plenary.nvim/blob/master/lua/plenary/log.lua

function M.execute_nvimrcs()
	local nvimrcs = vim.fn.findfile(".nvimrc", ".;", -1)

	-- TODO: load from the least specific to the most specific (from fs root downwards)
	for _, nvimrc_path in ipairs(nvimrcs) do
		print("Source " .. nvimrc_path .. "? [y]/n: ")
		local choice = vim.fn.getcharstr()
		if string.lower(choice) ~= "n" then
			print("Sourcing " .. nvimrc_path)
			vim.cmd("source " .. nvimrc_path)
		end
	end
end

return M
