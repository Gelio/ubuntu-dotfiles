---@class LspSourcesConfig
---@field lsp_keyword_pattern string?
---@field lsp_trigger_characters string[]?

---@param config LspSourcesConfig?
local function prepare_sources(config)
	config = config or {}

	-- NOTE: order matters. The order will be maintained in completions popup
	local sources = {
		{
			name = "nvim_lsp",
			label = "LSP",
			keyword_pattern = config.lsp_keyword_pattern,
			trigger_characters = config.lsp_trigger_characters,
		},
		{ name = "crates", label = "crates.nvim" },
		{ name = "natdat" },
		{ name = "npm" },
		{ name = "luasnip" },
		{ name = "nvim_lua" },
		{ name = "path" },
		{
			name = "buffer",
			keyword_length = 4,
			-- See https://github.com/hrsh7th/cmp-buffer#visible-buffers
			option = {
				get_bufnrs = function()
					local bufs = {}
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						bufs[vim.api.nvim_win_get_buf(win)] = true
					end
					return vim.tbl_keys(bufs)
				end,
			},
		},
		{ name = "tmux", keyword_length = 4 },
		{ name = "calc" },
		{ name = "emoji" },
	}

	local source_labels = {}

	for _, source in ipairs(sources) do
		source_labels[source.name] = string.format("[%s]", source.label or source.name)
	end

	return sources, source_labels
end

return {
	prepare_sources = prepare_sources,
}
