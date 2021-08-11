vim.o.relativenumber = true
vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrap = false
vim.o.mouse = "a"
vim.o.scrolloff = 5

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.colorcolumn = "+0,120"
vim.o.updatetime = 100

vim.o.secure = true
vim.o.exrc = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.o.termguicolors = true

local map = vim.api.nvim_set_keymap

-- Easier moving text
map("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
map("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })
map("v", "<<", "<<gv", { noremap = true })
map("v", ">>", ">>gv", { noremap = true })

-- Better search & replace
map("n", "cn", "*``cgn", { noremap = true })
map("n", "cN", "*``cgN", { noremap = true })

-- Center after J
map("n", "J", "mzJ`z", { noremap = true })

-- Mutate jumplist on longer jumps
map("n", "k", [[(v:count > 5 ? "m'" . v:count : "") . 'k']], { noremap = true, expr = true })
map("n", "j", [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { noremap = true, expr = true })

vim.opt.diffopt:append("algorithm:histogram,iwhite,indent-heuristic,vertical")

-- Use ripgrep instead of regular grep
vim.cmd([[
  if executable('rg')
      set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
      set grepformat=%f:%l:%c:%m,%f:%l:%m
  else
      echoerr "rg (ripgrep) is not installed. Thus, it will not be used for :grep"
  endif
]])

vim.cmd([[source $HOME/.config/nvim/code-review.vim]])
require("plugins")

-- NOTE: Manually source .nvimrc
-- https://github.com/neovim/neovim/issues/13501#issuecomment-758604989
local local_vimrc = vim.fn.getcwd() .. "/.nvimrc"
if vim.loop.fs_stat(local_vimrc) then
	vim.cmd("source " .. local_vimrc)
end
