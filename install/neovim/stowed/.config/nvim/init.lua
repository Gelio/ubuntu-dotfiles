vim.o.relativenumber = true
vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrap = false
vim.o.mouse = "a"
vim.o.scrolloff = 5
vim.o.hidden = true
vim.o.writebackup = false
vim.o.swapfile = false

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.colorcolumn = "+1,120"
vim.o.updatetime = 100

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

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
vim.opt.diffopt:append("algorithm:histogram,iwhite,indent-heuristic,vertical")

local map = vim.api.nvim_set_keymap

-- NOTE: Those were hard to be set via which-key.nvim

-- Mutate jumplist on longer jumps
map("n", "k", [[(v:count > 5 ? "m'" . v:count : "") . 'k']], { noremap = true, expr = true })
map("n", "j", [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { noremap = true, expr = true })

-- Alt + vim keys for resizing windows
map("n", "<A-h>", "<C-w><", { noremap = true })
map("n", "<A-j>", "<C-w>-", { noremap = true })
map("n", "<A-k>", "<C-w>+", { noremap = true })
map("n", "<A-l>", "<C-w>>", { noremap = true })
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

vim.cmd([[
  augroup HighlightYank
    autocmd! TextYankPost * silent! lua vim.highlight.on_yank { higroup="IncSearch", timeout=300 }
  augroup END
]])

-- Bootstrap packer
-- https://github.com/wbthomason/packer.nvim#bootstrapping
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = nil
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

require("plugins")(packer_bootstrap)
