" Enable number lines
set relativenumber
set number

" Smarter search (regardless of case)
set ignorecase
set smartcase

" Scrolling offset
set scrolloff=5

" Tab width and expanding tabs
set shiftwidth=2
set tabstop=2
set expandtab

autocmd FileType vim setlocal sw=4 ts=4 noexpandtab


" ============== PLUGINS ==================

" If the following does not work, install vim-plug
" See https://github.com/junegunn/vim-plug
" Run ":PlugInstall" to install the plugins
call plug#begin()

" https://vimawesome.com/plugin/sensible-vim
Plug 'tpope/vim-sensible'

" https://vimawesome.com/plugin/surround-vim
Plug 'tpope/vim-surround'

" https://vimawesome.com/plugin/vim-airline-superman
Plug 'vim-airline/vim-airline'

" https://github.com/wellle/targets.vim
Plug 'wellle/targets.vim'

" https://vimawesome.com/plugin/camelcasemotion-ours
Plug 'bkad/camelcasemotion'
let g:camelcasemotion_key = '<leader>'

" https://vimawesome.com/plugin/vim-highlightedyank
Plug 'machakann/vim-highlightedyank'

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

else
	" Regular easymotion
	" https://github.com/easymotion/vim-easymotion
	Plug 'easymotion/vim-easymotion'

	" https://vimawesome.com/plugin/nerdtree-red
	Plug 'scrooloose/nerdtree'
	nnoremap <leader>n :NERDTreeToggle<CR>

	" https://vimawesome.com/plugin/fugitive-vim
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-rhubarb' " Plugin for GitHub

	" https://vimawesome.com/plugin/gruvbox
	Plug 'morhetz/gruvbox'
	autocmd vimenter * ++nested colorscheme gruvbox
	set termguicolors

	" https://vimawesome.com/plugin/indentline
	Plug 'yggdroot/indentline'

	" https://vimawesome.com/plugin/rainbow-you-belong-with-me
	Plug 'luochen1990/rainbow'
	let g:rainbow_active = 1

	" https://vimawesome.com/plugin/vim-css-color-the-story-of-us
	Plug 'ap/vim-css-color'

	" https://vimawesome.com/plugin/vim-gitgutter
	Plug 'airblade/vim-gitgutter'
	" Enable faster reload for the gutter
	set updatetime=100

	" Telescope for fuzzy searching
	" https://github.com/nvim-telescope/telescope.nvim
	Plug 'nvim-lua/popup.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	nnoremap <leader>ff <cmd>Telescope find_files<cr>
	nnoremap <leader>fg <cmd>Telescope live_grep<cr>
	nnoremap <leader>fb <cmd>Telescope buffers<cr>
	nnoremap <leader>fh <cmd>Telescope help_tags<cr>
	nnoremap <leader>ft <cmd>Telescope treesitter<cr>

	Plug 'ryanoasis/vim-devicons'
	let g:airline_powerline_fonts = 1

	" https://github.com/tpope/vim-unimpaired
	Plug 'tpope/vim-unimpaired'

	" https://github.com/tpope/vim-commentary
	Plug 'tpope/vim-commentary'

	" Conquer of Completion
	" https://github.com/neoclide/coc.nvim
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	set hidden
	set nowritebackup
	" More space for displaying messages
	set cmdheight=2
	set shortmess+=c
	let g:coc_global_extensions = ['coc-json', 'coc-git',
		\ 'coc-tsserver', 'coc-prettier', 'coc-marketplace',
		\ 'coc-vimlsp', 'coc-css', 'coc-eslint', 'coc-go',
		\ 'coc-html', 'coc-markdownlint', 'coc-rust-analyzer',
		\ 'coc-sh', 'coc-stylelintplus', 'coc-toml', 'coc-tabnine',
		\ 'coc-xml', 'coc-yaml']

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

	" GoTo code navigation.
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

	" Ctrl-Space triggers help like VSCode
	inoremap <silent><expr> <c-space> coc#refresh()

	" Treesitter
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif


call plug#end()

if !exists('g:vscode')
lua << EOF
require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true
	},
}
EOF
endif
