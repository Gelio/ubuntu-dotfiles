return vim.tbl_extend(
	"error",
	-- Conflicts with prettier formatting in JSON files.
	require("lsp.utils").base_config_without_formatting,
	{
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
			},
		},
	}
)
