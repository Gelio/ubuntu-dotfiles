" Enable number lines
set relativenumber
set number

" Smarter search (regardless of case)
set ignorecase
set smartcase

" Scrolling offset
set scrolloff=5


" ============== PLUGINS ==================

" If the following does not work, install vim-plug
" See https://github.com/junegunn/vim-plug
" Run ":PlugInstall" to install the plugins
call plug#begin()

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

	" https://vimawesome.com/plugin/vim-gitgutter
	Plug 'airblade/vim-gitgutter'
	" Enable faster reload for the gutter
	set updatetime=100

endif


call plug#end()
