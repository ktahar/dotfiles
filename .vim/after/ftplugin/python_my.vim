if exists('b:did_ftplugin_python_my')
    finish
endif
let b:did_ftplugin_python_my = 1

setl fileencoding=utf-8
setl foldmethod=indent

" setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
" setl omnifunc=jedi#completions "this is done automatically

" Execute current file \e
function! s:ExecPy()
    cd %:h
    !python %
endfunction
" command! -buffer Exec call <SID>ExecPy()
nnoremap <silent><buffer> <LocalLeader>e :call <SID>ExecPy()<CR>

" Execute current file (interactive) \E
function! s:ExecPy_i()
    cd %:h
    !python -i %
endfunction
" command! -buffer Exec call <SID>ExecPy()
nnoremap <silent><buffer> <LocalLeader>E :call <SID>ExecPy_i()<CR>
