local ls = require("luasnip")
local M = {}

ls.filetype_extend("typescriptreact", { "javascriptreact", "typescript" })
ls.filetype_extend("typescript", { "javascript" })

---@param index number
local function copy_node(index)
	return ls.function_node(function(args)
		return args[1]
	end, { index })
end

function M.setup()
	ls.add_snippets("typescriptreact", {
		ls.snippet({ trig = "rfcp", name = "React function component with props interface" }, {
			ls.text_node("interface "),
			copy_node(1),
			ls.text_node({ "Props {", "" }),
			ls.function_node(function(args)
				---@type string[]
				local props_lines = args[1]
				local individual_props = vim.tbl_flatten(vim.tbl_map(function(line)
					local words = vim.fn.split(line, ",")

					local trimmed_words = vim.tbl_map(function(word)
						return string.gsub(word, "%s+", "")
					end, words)

					return vim.tbl_filter(function(word)
						return string.len(word) > 0
					end, trimmed_words)
				end, props_lines))

				if vim.tbl_count(individual_props) == 0 then
					return ""
				end

				return vim.tbl_map(function(prop_name)
					return "  " .. prop_name .. ": unknown;"
				end, individual_props)
			end, { 2 }),
			ls.text_node({ "", "}", "", "export const " }),
			ls.dynamic_node(1, function()
				local file_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")
				local initial_text = file_name or "MyComponent"
				return ls.snippet_node(nil, ls.insert_node(1, initial_text))
			end, {}),
			ls.text_node(" = ({ "),
			ls.insert_node(2, ""),
			ls.text_node(" }: "),
			copy_node(1),
			ls.text_node({ "Props) => {", "  return <div>" }),
			copy_node(1),
			ls.text_node({ "</div>;", "}" }),
		}),
	})
end

return M
