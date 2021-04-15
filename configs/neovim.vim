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

" https://vimawesome.com/plugin/sensible-vim
Plug 'tpope/vim-sensible'

" https://vimawesome.com/plugin/surround-vim
Plug 'tpope/vim-surround'

" https://github.com/wellle/targets.vim
Plug 'wellle/targets.vim'

" https://vimawesome.com/plugin/camelcasemotion-ours
Plug 'bkad/camelcasemotion'
let g:camelcasemotion_key = '<leader>'

" https://vimawesome.com/plugin/vim-highlightedyank
Plug 'machakann/vim-highlightedyank'

" https://github.com/tpope/vim-unimpaired
Plug 'tpope/vim-unimpaired'

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

	" Mimic NERDTree mappings
	nnoremap <leader>nn :call VSCodeNotify('workbench.files.action.showActiveFileInExplorer')<CR>
	nnoremap <leader>ng :call VSCodeNotify('workbench.files.action.showActiveFileInExplorer')<CR>
	nnoremap <leader>nr :call VSCodeNotify('workbench.files.action.showActiveFileInExplorer')<CR>
	nnoremap <leader>nR :call VSCodeNotify('workbench.files.action.showActiveFileInExplorer')<CR>
else
	" Regular easymotion
	" https://github.com/easymotion/vim-easymotion
	Plug 'easymotion/vim-easymotion'

	" Status line
	" https://github.com/hoob3rt/lualine.nvim
	Plug 'hoob3rt/lualine.nvim'

	" https://vimawesome.com/plugin/nerdtree-red
	Plug 'scrooloose/nerdtree'
	nnoremap <leader>nn :NERDTreeToggle<CR>
	nnoremap <leader>ng :NERDTreeToggleVCS<CR>
	nnoremap <leader>nr :NERDTreeFind<CR>
	nnoremap <silent> <leader>nR :NERDTreeFind<CR> :wincmd p<CR>

	" https://vimawesome.com/plugin/nerdtree-git-plugin
	Plug 'xuyuanp/nerdtree-git-plugin'
	let g:NERDTreeGitStatusUseNerdFonts = 1

	" https://vimawesome.com/plugin/fugitive-vim
	" Plug 'tpope/vim-fugitive'
	" Use my fork for showing refs in Gstatus
	Plug 'Gelio/vim-fugitive', { 'branch': 'show-refs-in-status', 'as': 'forked-vim-fugitive' }
	Plug 'tpope/vim-rhubarb' " Plugin for GitHub
	Plug 'junegunn/gv.vim' " commit graph

	" Better diffs (shows in-line changes)
	" https://github.com/rickhowe/diffchar.vim
	Plug 'rickhowe/diffchar.vim'

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
	autocmd vimenter * ++nested colorscheme gruvbox
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

	" Install both icon plugins
	" web-devicons for telescope
	" devicons for airline and NERDTree
	Plug 'kyazdani42/nvim-web-devicons'
	Plug 'ryanoasis/vim-devicons'
	Plug 'lambdalisue/glyph-palette.vim'
	augroup my-glyph-palette
		autocmd! *
		autocmd FileType fern call glyph_palette#apply()
		autocmd FileType nerdtree,startify call glyph_palette#apply()
		autocmd ColorScheme * lua require'nvim-web-devicons'.setup()
	augroup END

	" https://github.com/tpope/vim-commentary
	Plug 'tpope/vim-commentary'

	" Conquer of Completion
	" https://github.com/neoclide/coc.nvim
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	set hidden
	set nowritebackup
	set noswapfile
	" More space for displaying messages
	set cmdheight=2
	set shortmess+=c
	" Display both gitsigns and CoC markers at all times.
	" Prevents the text from moving around horizontally when markers appear
	set signcolumn=yes:2
	autocmd FileType nerdtree :setlocal signcolumn=auto

	let g:coc_global_extensions = ['coc-json', 'coc-react-refactor',
				\ 'coc-tsserver', 'coc-prettier', 'coc-marketplace',
				\ 'coc-vimlsp', 'coc-css', 'coc-eslint', 'coc-go',
				\ 'coc-html', 'coc-markdownlint', 'coc-rust-analyzer',
				\ 'coc-sh', 'coc-stylelintplus', 'coc-toml', 'coc-tabnine',
				\ 'coc-gitignore', 'coc-lua', 'coc-svelte',
				\ 'coc-xml', 'coc-yaml', 'coc-styled-components']

	" Tab and Shift-Tab for moving through completions
	inoremap <silent><expr> <TAB>
				\ pumvisible() ? "\<C-n>" :
				\ <SID>check_back_space() ? "\<TAB>" :
				\ coc#refresh()
	inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

	function! s:check_back_space() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" <CR> to select the completion
	inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
				\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

	" [g and ]g to move through diagnostics
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)

	" Move through the CocList
	nnoremap <leader>cn :CocNext<CR>
	nnoremap <leader>cp :CocPrev<CR>
	nnoremap <leader>co :CocListResume<CR>

	" GoTo code navigation.
	nnoremap <silent> <C-W>gd :call CocActionAsync('jumpDefinition', 'tab drop')<CR>
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	" List symbols
	nnoremap <leader>fs <cmd>CocList symbols<CR>

	" Use K to show documentation in preview window.
	nnoremap <silent> K :call <SID>show_documentation()<CR>

	function! s:show_documentation()
		if (index(['vim','help'], &filetype) >= 0)
			execute 'h '.expand('<cword>')
		elseif (coc#rpc#ready())
			call CocActionAsync('doHover')
		else
			execute '!' . &keywordprg . " " . expand('<cword>')
		endif
	endfunction

	" Highlight the symbol and its references when holding the cursor.
	autocmd CursorHold * silent call CocActionAsync('highlight')

	" Symbol renaming.
	nmap <leader>rn <Plug>(coc-rename)

	" Formatting
	xmap <leader>F  <Plug>(coc-format)
	nmap <leader>F  <Plug>(coc-format)

	" Map function and class text objects
	xmap if <Plug>(coc-funcobj-i)
	omap if <Plug>(coc-funcobj-i)
	xmap af <Plug>(coc-funcobj-a)
	omap af <Plug>(coc-funcobj-a)
	xmap ic <Plug>(coc-classobj-i)
	omap ic <Plug>(coc-classobj-i)
	xmap ac <Plug>(coc-classobj-a)
	omap ac <Plug>(coc-classobj-a)

	" Code actions
	xmap <leader>a  <Plug>(coc-codeaction-selected)
	nmap <leader>a  <Plug>(coc-codeaction-selected)
	xmap <leader>ac  <Plug>(coc-codeaction)
	nmap <leader>ac  <Plug>(coc-codeaction)

	" Scroll in popup windows
	nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
	inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
	vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

	" Quick fix
	xmap <leader>qf :CocAction quickfix<CR>
	nmap <leader>qf :CocAction quickfix<CR>

	" Add `:Format` command to format current buffer.
	command! -nargs=0 Format :call CocAction('format')

	" Add `:Fold` command to fold current buffer.
	command! -nargs=? Fold :call     CocAction('fold', <f-args>)
	set foldlevelstart=20

	" Ctrl-Space triggers help like VSCode
	inoremap <silent><expr> <c-space> coc#refresh()

	" Treesitter
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'nvim-treesitter/playground'
	Plug 'nvim-treesitter/nvim-treesitter-textobjects'

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
EOF

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

endif
