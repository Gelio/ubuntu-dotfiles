local M = {}

local system_name
if vim.fn.has("mac") == 1 then
	system_name = "mac"
elseif vim.fn.has("unix") == 1 then
	system_name = "linux"
else
	system_name = "windows"
end

local HOME = vim.fn.expand("$HOME")

M.config = vim.tbl_extend(
	"error",
	require("lsp.utils").base_config,
	{ cmd = { HOME .. "/.local/java-language-server/dist/lang_server_" .. system_name .. ".sh" } }
)

return M
