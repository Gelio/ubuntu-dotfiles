local M = {}

-- Conflicts with prettier formatting in JSON files.
M.config = vim.tbl_extend("error", require("lsp.utils").base_config_without_formatting, {
	get_language_id = function(_, filetype)
		if filetype == "json" then
			-- NOTE: allows comments in JSON files
			return "jsonc"
		end
		return filetype
	end,
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
		},
	},
})

return M
