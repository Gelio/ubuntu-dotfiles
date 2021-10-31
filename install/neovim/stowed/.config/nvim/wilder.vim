set wildcharm=<Tab>
cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"

call wilder#setup({'modes': ['/', '?', ':']})
call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     wilder#python_file_finder_pipeline({
      \       'file_command': ['rg', '--files'],
      \       'dir_command': ['fd', '-td'],
      \       'filters': ['fuzzy_filter', 'difflib_sorter'],
      \     }),
      \     wilder#cmdline_pipeline(),
      \     wilder#python_search_pipeline(),
      \   ),
      \ ])

let s:search_renderer = wilder#wildmenu_renderer({
    \ 'mode': 'statusline',
    \ 'right': [' ', wilder#wildmenu_index()]
    \ })
call wilder#set_option('renderer', wilder#renderer_mux({
    \ ':': wilder#popupmenu_renderer({
    \  'highlighter': wilder#basic_highlighter(),
    \  'left': [
    \   wilder#popupmenu_devicons(),
    \  ],
    \ }),
    \ '/': s:search_renderer,
    \ '?': s:search_renderer,
    \ }))
