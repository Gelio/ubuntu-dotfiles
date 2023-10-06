local M = {}

---@param language string
---@return string
local function get_spellfile(language)
	local nvim_config_path = vim.opt.runtimepath:get()[1]
	local encoding = vim.o.encoding
	local spellfile_name = language .. "." .. encoding .. ".add"

	return vim.fs.joinpath(nvim_config_path, "spell", spellfile_name)
end

---Sets the 'spellfile' based on the spelllangs
---@param spelllangs string[]? For example {"en", "pl"}. Defaults to 'spelllang'
function M.set_spellfile(spelllangs)
	spelllangs = spelllangs or vim.opt.spelllang:get()
	vim.opt.spellfile = vim.tbl_map(get_spellfile, spelllangs)
end

function M.setup()
	vim.api.nvim_create_user_command("SpellFile", function(params)
		if #params.fargs == 1 then
			M.set_spellfile({ params.fargs[1] })
		else
			M.set_spellfile()
		end
	end, {
		desc = "Set the spellfile based on the language",
		complete = function()
			return { "pl", "en" }
		end,
		nargs = "?",
	})
end

return M
