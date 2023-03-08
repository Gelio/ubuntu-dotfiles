-- NOTE: execute https://github.com/tpope/vim-sensible at the start so it does
-- not override my configuration
vim.cmd.runtime("plugin/sensible.vim")
vim.o.relativenumber = true
vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrap = false
vim.o.mouse = "a"
vim.o.scrolloff = 5
vim.o.sidescrolloff = 8
vim.o.hidden = true
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.signcolumn = "yes:2"

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.colorcolumn = "+1,120"
vim.o.updatetime = 100

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.opt.spell = true
vim.opt.spelloptions:append("camel")

vim.opt.path:remove("/usr/include")

vim.o.list = true
-- Source: https://github.com/tjdevries/cyclist.vim
vim.opt.listchars = {
	["tab"] = "» ",
	["trail"] = "·",
	["extends"] = "<",
	["precedes"] = ">",
	["conceal"] = "┊",
	["nbsp"] = "␣",
}

vim.o.termguicolors = true
vim.opt.diffopt:append({
	"algorithm:histogram",
	"iwhite",
	"indent-heuristic",
	"vertical",
	"linematch:60",
})

local map = vim.api.nvim_set_keymap

-- NOTE: Those were hard to be set via which-key.nvim

-- Mutate jumplist on longer jumps
map("n", "k", [[(v:count > 5 ? "m'" . v:count : "") . 'k']], { noremap = true, expr = true })
map("n", "j", [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { noremap = true, expr = true })

-- Easy yanking to clipboard
map("n", "<Leader>y", '"+y', { noremap = true })
map("v", "<Leader>y", '"+y', { noremap = true })
-- Use ripgrep instead of regular grep
if vim.fn.executable("rg") then
	vim.o.grepprg = "rg --vimgrep --no-heading --smart-case"
	vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
else
	vim.fn.echoerr("rg (ripgrep) is not installed. Thus, it will not be used for :grep")
end

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("HighlightYank", {}),
	desc = "Highlight yanked text",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
	end,
})

-- Bootstrap lazy.nvim
-- https://github.com/folke/lazy.nvim#-installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("globals")
require("lazy").setup("plugins")
