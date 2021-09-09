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
			schemas = {
				-- Sources
				-- 1. VSCode
				--    https://github.com/microsoft/vscode/blob/6e5ffbde32cb783be15ddd383028c4a56a667edd/extensions/typescript-language-features/package.json#L70
				--    Use http://mageddo.com/tools/json-to-lua-converter
				--
				-- 2. SchemaStore
				--    https://www.schemastore.org/json/
				{
					fileMatch = { "package.json" },
					url = "https://json.schemastore.org/package",
				},
				{
					fileMatch = { "tsconfig.json", "tsconfig-*.json", "tsconfig.*.json" },
					url = "https://json.schemastore.org/tsconfig",
				},
				{
					fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
					url = "https://json.schemastore.org/babelrc",
				},
				{
					fileMatch = { "jsconfig.json", "jsconfig.*.json" },
					url = "https://json.schemastore.org/jsconfig",
				},
				{
					fileMatch = { ".prettierrc", ".prettierrc.json" },
					url = "https://json.schemastore.org/prettierrc.json",
				},
				{
					fileMatch = { "cypress.json" },
					url = "https://raw.githubusercontent.com/cypress-io/cypress/develop/cli/schema/cypress.schema.json",
				},
			},
		},
	},
})

return M
