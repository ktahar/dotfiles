if exists('b:did_ftplugin_python_my')
    finish
endif
let b:did_ftplugin_python_my = 1

setl fileencoding=utf-8
setl foldmethod=indent

" setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" Execute current file (python3 -> python): <Leader>e
function! s:ExecPy()
    lcd %:h
    if executable('python3')
        !python3 %
    elseif executable('python')
        !python %
    endif
endfunction
" command! -buffer Exec call <SID>ExecPy()
nnoremap <silent><buffer> <Leader>e :call <SID>ExecPy()<CR>

" Execute current file (python3 -> python, interactive): <Leader>i
function! s:ExecPy_i()
    lcd %:h
    if executable('python3')
        !python3 -i %
    elseif executable('python')
        !python -i %
    endif
endfunction
nnoremap <silent><buffer> <Leader>i :call <SID>ExecPy_i()<CR>

" Execute current file (python2): <Leader>E
function! s:ExecPy2()
    lcd %:h
    if executable('python')
        !python %
    endif
endfunction
nnoremap <silent><buffer> <Leader>E :call <SID>ExecPy2()<CR>

" Execute current file (python2, interactive): <Leader>I
function! s:ExecPy2_i()
    lcd %:h
    if executable('python')
        !python -i %
    endif
endfunction
nnoremap <silent><buffer> <Leader>I :call <SID>ExecPy2_i()<CR>
