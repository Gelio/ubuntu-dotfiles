local autolist_filetypes = {
	"markdown",
	"text",
	"tex",
	"plaintex",
	"norg",
}

return {
	"gaoDean/autolist.nvim",
	ft = autolist_filetypes,
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = autolist_filetypes,
			group = vim.api.nvim_create_augroup("AutolistKeybinds", {}),
			callback = function()
				local function add_local_keymap(mode, lhs, rhs, opts)
					opts = opts or {}
					opts.buffer = 0
					vim.keymap.set(mode, lhs, rhs, opts)
				end

				add_local_keymap("i", "<tab>", "<cmd>AutolistTab<cr>")
				add_local_keymap("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
				add_local_keymap("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
				add_local_keymap("n", "o", "o<cmd>AutolistNewBullet<cr>")
				add_local_keymap("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
				add_local_keymap("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>")
				add_local_keymap("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")

				-- cycle list types with dot-repeat
				add_local_keymap("n", "<leader>ln", require("autolist").cycle_next_dr, { expr = true, desc = "Next list type" })
				add_local_keymap(
					"n",
					"<leader>lp",
					require("autolist").cycle_prev_dr,
					{ expr = true, desc = "Previous list type" }
				)

				-- functions to recalculate list on edit
				add_local_keymap("n", ">>", ">><cmd>AutolistRecalculate<cr>")
				add_local_keymap("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
				add_local_keymap("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
				add_local_keymap("v", "d", "d<cmd>AutolistRecalculate<cr>")
			end,
		})
	end,
	opts = true,
}
