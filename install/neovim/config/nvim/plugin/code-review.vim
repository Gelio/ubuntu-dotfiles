" ====== Code review ======
command! -nargs=1 -complete=customlist,fugitive#EditComplete CodeReview :call s:CodeReview(<f-args>)
let s:review_branch = ''
function! s:CodeReview(review_branch)
    let s:review_branch = trim(system("git merge-base HEAD " . a:review_branch))
    execute("G difftool --name-status " . s:review_branch)
	nnoremap <leader>d :call <SID>CodeReviewDiff()<CR>
endfunction

function! s:CodeReviewDiff()
    exec "Gdiffsplit " . s:review_branch
endfunction
