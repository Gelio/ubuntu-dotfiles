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

	" https://vimawesome.com/plugin/fzf
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	nnoremap <leader>p :FZF<CR>
	nnoremap <C-P> :FZF<CR>

	" https://github.com/tpope/vim-unimpaired
	Plug 'tpope/vim-unimpaired'

	" https://github.com/tpope/vim-commentary
	Plug 'tpope/vim-commentary'
endif


call plug#end()
