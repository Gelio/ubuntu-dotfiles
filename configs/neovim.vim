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

if exists('g:vscode')
	" https://github.com/asvetliakov/vim-easymotion
	" Fork of the original easymotion that works correctly in vscode
	" Unfortunately, then it does not work in regular nvim :/
	Plug 'https://github.com/asvetliakov/vim-easymotion', { 'as': 'vscode-vim-easymotion' }
else
	" Regular easymotion
	" https://github.com/easymotion/vim-easymotion
	Plug 'easymotion/vim-easymotion'
endif


call plug#end()
