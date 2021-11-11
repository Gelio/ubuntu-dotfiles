local M = {}

function M.setup()
	require("which-key").register({
		name = "Refactor",
		t = { "<cmd>lua require('refactor').show_refactors()<CR>", "Choose a refactor" },
	}, {
		prefix = "<Leader>r",
		mode = "v",
	})
end

M.show_refactors = function()
	local refactoring = require("refactoring")
	refactoring.setup()

	local func = require("plenary.functional")

	local function refactor(prompt_bufnr)
		local content = require("telescope.actions.state").get_selected_entry()
		require("telescope.actions").close(prompt_bufnr)
		refactoring.refactor(content[1])
	end

	local opts = require("telescope.themes").get_cursor()
	require("telescope.pickers").new(opts, {
		prompt_title = "refactors",
		finder = require("telescope.finders").new_table({
			results = require("refactoring").get_refactors(),
		}),
		sorter = require("telescope.config").values.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr)
			local actions = require("telescope.actions")
			actions.select_default:replace(func.partial(refactor, prompt_bufnr))
			return true
		end,
	}):find()
end

return M
