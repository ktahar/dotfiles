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
    if executable('python3')
        !python3 %
    elseif executable('python')
        !python %
    endif
endfunction
" command! -buffer Exec call <SID>ExecPy()
nnoremap <silent><buffer> <Leader>e :call <SID>ExecPy()<CR>

" Execute current file (interactive) \E
function! s:ExecPy_i()
    cd %:h
    if executable('python3')
        !python3 -i %
    elseif executable('python')
        !python -i %
    endif
endfunction
" command! -buffer Exec call <SID>ExecPy()
nnoremap <silent><buffer> <Leader>E :call <SID>ExecPy_i()<CR>