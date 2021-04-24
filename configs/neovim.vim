" Enable number lines
set relativenumber
set number

" Smarter search (regardless of case)
set ignorecase
set smartcase

" Turn off wrapping
set nowrap

" Enable mouse (shame)
set mouse=a

" Scrolling offset
set scrolloff=5

" Splits
set splitbelow splitright

" Tab width and expanding tabs
if !exists('g:tab_config_set')
	set shiftwidth=2
	set tabstop=2
	set expandtab
	let g:tab_config_set = 1
endif

" Column at text width and 120 chars
set colorcolumn=+0,120

" Refresh UI faster
set updatetime=100

" ============== PLUGINS ==================

" If the following does not work, install vim-plug
" See https://github.com/junegunn/vim-plug
" Run ":PlugInstall" to install the plugins
call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-unimpaired'

Plug 'bkad/camelcasemotion'
let g:camelcasemotion_key = '<leader>'

Plug 'machakann/vim-highlightedyank'

Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
" Leave ; and , for quick-scope (f, F, t, T)
" Idea from https://www.chrisatmachine.com/Neovim/13-sneak/
map gS <Plug>Sneak_,
map gs <Plug>Sneak_;

Plug 'unblevable/quick-scope'
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

if exists('g:vscode')
	" https://github.com/asvetliakov/vim-easymotion
	" Fork of the original easymotion that works correctly in vscode
	" Unfortunately, then it does not work in regular nvim :/
	Plug 'https://github.com/asvetliakov/vim-easymotion', { 'as': 'vscode-vim-easymotion' }

	" Mimic CoC mappings
	nnoremap <leader>qf :call VSCodeNotify('editor.action.quickFix')<CR>
	xnoremap <leader>qf :call VSCodeNotify('editor.action.quickFix')<CR>

	nnoremap [g :call VSCodeNotify('editor.action.marker.prev')<CR>
	nnoremap ]g :call VSCodeNotify('editor.action.marker.next')<CR>

	nnoremap <leader>rn :call VSCodeNotify('editor.action.rename')<CR>

	nnoremap <leader>fs :call VSCodeNotify('workbench.action.showAllSymbols')<CR>

	nnoremap gy :call VSCodeNotify('editor.action.goToTypeDefinition')<CR>
	nnoremap gi :call VSCodeNotify('editor.action.goToImplementation')<CR>
	nnoremap gr :call VSCodeNotify('editor.action.goToReferences')<CR>

	nnoremap <leader>F :call VSCodeNotify('editor.action.formatDocument')<CR>

	nnoremap <leader>ff :call VSCodeNotify('workbench.action.quickOpen')<CR>
	nnoremap <leader>fg :call VSCodeNotify('workbench.action.findInFiles')<CR>

	" Mimic directory tree mappings
	nnoremap <leader>nn :call VSCodeNotify('workbench.files.action.showActiveFileInExplorer')<CR>
	nnoremap <leader>nr :call VSCodeNotify('workbench.files.action.showActiveFileInExplorer')<CR>
else
	" Regular easymotion
	" https://github.com/easymotion/vim-easymotion
	Plug 'easymotion/vim-easymotion'

	" Status line
	" https://github.com/hoob3rt/lualine.nvim
	Plug 'hoob3rt/lualine.nvim'

	" https://github.com/kyazdani42/nvim-tree.lua (NERDTree in lua)
	Plug 'kyazdani42/nvim-tree.lua'
	nnoremap <leader>nn :NvimTreeToggle<CR>
	nnoremap <leader>nr :NvimTreeFindFile<CR>
	nnoremap <silent> <leader>nR :NvimTreeFindFile<CR> :wincmd p<CR>
	let g:nvim_tree_git_hl=1
	let g:nvim_tree_lsp_diagnostics = 1

	" https://vimawesome.com/plugin/fugitive-vim
	" Plug 'tpope/vim-fugitive'
	" Use my fork for showing refs in Gstatus
	Plug 'Gelio/vim-fugitive', { 'branch': 'show-refs-in-status', 'as': 'forked-vim-fugitive' }
	Plug 'tpope/vim-rhubarb' " Plugin for GitHub
	Plug 'junegunn/gv.vim' " commit graph

	" Better diffs (shows in-line changes)
	" https://github.com/rickhowe/diffchar.vim
	Plug 'rickhowe/diffchar.vim'

	" https://github.com/jiangmiao/auto-pairs
	Plug 'jiangmiao/auto-pairs'

	" https://github.com/mbbill/undotree
	Plug 'mbbill/undotree'
	set undofile

	" Better quickfix
	" https://github.com/kevinhwang91/nvim-bqf
	Plug 'kevinhwang91/nvim-bqf'

	" Saving sessions
	" https://github.com/tpope/vim-obsession
	Plug 'tpope/vim-obsession'

	" ===== Theme ====
	" Use gruvbox for regular development
	" Use codedark for code review (in diffs) for syntax highlighting of diff
	" code
	" TODO: configure the Diff colors for gruvbox to preserve syntax
	" highlighting and stop using 2 color schemes :D

	" https://github.com/tomasiser/vim-code-dark
	Plug 'tomasiser/vim-code-dark'

	" https://vimawesome.com/plugin/gruvbox
	Plug 'morhetz/gruvbox'
	set termguicolors

	" https://github.com/lukas-reineke/indent-blankline.nvim
	Plug 'lukas-reineke/indent-blankline.nvim', { 'branch': 'lua' }
	let g:indent_blankline_show_current_context = v:true
	let g:indent_blankline_context_patterns = ['class', 'function', 'method',
				\ 'if_statement', 'else_clause', 'jsx_element', 'jsx_self_closing_element',
				\ 'try_statement', 'catch_clause']

	" https://vimawesome.com/plugin/rainbow-you-belong-with-me
	Plug 'luochen1990/rainbow'
	let g:rainbow_active = 1

	" https://vimawesome.com/plugin/vim-css-color-the-story-of-us
	Plug 'ap/vim-css-color'

	" https://github.com/lewis6991/gitsigns.nvim
	Plug 'lewis6991/gitsigns.nvim'

	" Telescope for fuzzy searching
	" https://github.com/nvim-telescope/telescope.nvim
	Plug 'nvim-lua/popup.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
	nnoremap <leader>fg <cmd>Telescope live_grep<cr>
	nnoremap <leader>fb <cmd>Telescope buffers<cr>
	nnoremap <leader>fh <cmd>Telescope help_tags<cr>
	nnoremap <leader>ft <cmd>Telescope treesitter<cr>
	nnoremap <leader>fo <cmd>Telescope oldfiles<cr>
	nnoremap <leader>fr <cmd>Telescope lsp_references<cr>
	nnoremap <leader>fs <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
	nnoremap <leader>fac <cmd>Telescope lsp_code_actions<cr>
	nnoremap <leader>far <cmd>Telescope lsp_range_code_actions<cr>

	Plug 'kyazdani42/nvim-web-devicons'

	" https://github.com/tpope/vim-commentary
	Plug 'tpope/vim-commentary'

	" LSP
	Plug 'neovim/nvim-lspconfig'
	set hidden
	set nowritebackup
	set noswapfile
	" More space for displaying messages
	set cmdheight=2
	set shortmess+=c
	set signcolumn=yes
	Plug 'nvim-lua/lsp_extensions.nvim'

	Plug 'simrat39/symbols-outline.nvim'
	nnoremap <leader>so :SymbolsOutline<cr>

	" nvim-compe
	" https://github.com/hrsh7th/nvim-compe
	Plug 'hrsh7th/nvim-compe'
	set completeopt=menuone,noselect
	inoremap <silent><expr> <C-Space> compe#complete()
	inoremap <silent><expr> <CR>      compe#confirm('<CR>')
	inoremap <silent><expr> <C-y>     compe#close('<C-e>')
	inoremap <silent><expr> <C-u>     compe#scroll({ 'delta': +4 })
	inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
	Plug 'tzachar/compe-tabnine', { 'do': './install.sh' }

	" Pretty list of LSP diagnostics
	" https://github.com/folke/lsp-trouble.nvim
	Plug 'folke/lsp-trouble.nvim'
	nnoremap <leader>d <cmd>LspTroubleToggle<cr>

	" Treesitter
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'nvim-treesitter/playground'
	Plug 'nvim-treesitter/nvim-treesitter-textobjects'

	set foldmethod=expr
	set foldexpr=nvim_treesitter#foldexpr()
	set foldlevel=20

	" https://github.com/editorconfig/editorconfig-vim
	Plug 'editorconfig/editorconfig-vim'

	" https://github.com/windwp/nvim-ts-autotag
	Plug 'windwp/nvim-ts-autotag'

	" https://github.com/JoosepAlviste/nvim-ts-context-commentstring
	Plug 'JoosepAlviste/nvim-ts-context-commentstring'

	" ====== Diff options ======
	" Ignore whitespace in diffs
	set diffopt+=iwhite
	" Set a better diff algorithm
	set diffopt+=algorithm:histogram

	" ====== Code review ======
	command! -nargs=1 -complete=customlist,fugitive#EditComplete CodeReview
				\ 	:call s:CodeReview(<f-args>)
	let s:review_branch = ''
	function! s:CodeReview(review_branch)
		let s:review_branch = trim(system("git merge-base HEAD " . a:review_branch))
		execute("G difftool --name-status " . s:review_branch)
		nnoremap <leader>d :call <SID>CodeReviewDiff()<CR>
	endfunction

	function! s:CodeReviewDiff()
		exec "Gdiffsplit " . s:review_branch
	endfunction

	function! DeleteHiddenBuffers()
		let tpbl=[]
		let closed = 0
		call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
		for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
			if getbufvar(buf, '&mod') == 0
				silent execute 'bwipeout' buf
				let closed += 1
			endif
		endfor
		echo "Closed ".closed." hidden buffers"
	endfunction
	command! -nargs=0 DeleteHiddenBuffers :call DeleteHiddenBuffers()
endif


call plug#end()

if !exists('g:vscode')
lua << EOF
require'nvim-treesitter.configs'.setup {
	ensure_installed = "maintained",
	highlight = {
		enable = true
	},
	autotag = {
		enable = true,
	},
	context_commentstring = {
		enable = true,
	},
	textobjects = {
		-- See https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		swap = {
			enable = true,
			swap_next = {
				["]a"] = "@parameter.inner",
			},
			swap_previous = {
				["[a"] = "@parameter.inner",
			},
		}
	},
}
require('telescope').setup {
	defaults = {
		file_ignore_patterns = {".git"}
	}
}
require'nvim-web-devicons'.setup {
	default = true;
}
require('gitsigns').setup()
require('lualine').setup{
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch'},
		lualine_c = {'filename'},
		lualine_x = {{'diagnostics', sources = {'coc'}}, 'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'},
	}
}
require("trouble").setup {}
require('symbols-outline').setup{}
EOF
lua require('my-config')

" Disable treesitter in esbuild go files (very long ones, causes lags)
autocmd BufNewFile,BufRead */esbuild/*/*.go call DisableFeaturesForEsbuild()
function! DisableFeaturesForEsbuild()
	:TSDisableAll highlight go<cr>
	let g:indent_blankline_show_current_context = v:false
endfunction

" Use ripgrep instead of regular grep
if executable('rg')
	set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
	set grepformat=%f:%l:%c:%m,%f:%l:%m
else
	echoerr "rg (ripgrep) is not installed. Thus, it will not be used for :grep"
endif

set t_Co=256
colorscheme gruvbox

" Diagnostics
" Errors in Red
hi LspDiagnosticsVirtualTextError guifg=Red ctermfg=Red
hi LspDiagnosticsSignError guifg=Red ctermfg=Red
" Warnings in Yellow
hi LspDiagnosticsVirtualTextWarning guifg=Yellow ctermfg=Yellow
hi LspDiagnosticsSignError guifg=Red ctermfg=Yellow

" Underline the offending code
hi LspDiagnosticsUnderlineError guifg=NONE ctermfg=NONE cterm=underline gui=underline
hi LspDiagnosticsUnderlineWarning guifg=NONE ctermfg=NONE cterm=underline gui=underline
hi LspDiagnosticsUnderlineInformation guifg=NONE ctermfg=NONE cterm=underline gui=underline
hi LspDiagnosticsUnderlineHint guifg=NONE ctermfg=NONE cterm=underline gui=underline

autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints
	\{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }

endif
