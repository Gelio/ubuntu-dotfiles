set wildcharm=<Tab>
cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"

call wilder#setup({'modes': ['/', '?', ':']})
call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     wilder#python_file_finder_pipeline({
      \       'file_command': {_, arg -> stridx(arg, '.') != -1 ? ['fd', '-tf', '-H'] : ['fd', '-tf']},
      \       'dir_command': ['fd', '-td'],
      \       'filters': ['fuzzy_filter', 'difflib_sorter'],
      \	      'path': '',
      \     }),
      \     wilder#cmdline_pipeline({
      \       'fuzzy': 1,
      \     }),
      \     wilder#python_search_pipeline(),
      \   ),
      \ ])

let s:search_renderer = wilder#wildmenu_renderer({
    \   'mode': 'statusline',
    \   'right': [' ', wilder#wildmenu_index()],
    \   'apply_incsearch_fix': v:true,
    \ })

call wilder#set_option('renderer', wilder#renderer_mux({
    \ ':': wilder#popupmenu_renderer({
    \   'highlighter': wilder#basic_highlighter(),
    \   'left': [
    \     ' ', wilder#popupmenu_devicons(),
    \   ],
    \   'right': [
    \     ' ', wilder#popupmenu_scrollbar(),
    \   ],
    \ }),
    \ '/': s:search_renderer,
    \ '?': s:search_renderer,
    \ }))

" vim: tabstop=2,expandtab,softtabstop=2,shiftwidth=2
