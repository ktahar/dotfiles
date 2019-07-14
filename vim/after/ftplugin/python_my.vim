if exists('b:did_ftplugin_python_my')
    finish
endif
let b:did_ftplugin_python_my = 1

setl fileencoding=utf-8
setl foldmethod=indent

" LSP mappings
nnoremap <LocalLeader>d :<C-u>LspDefinition<CR>

" Execute current file (python3 -> python): <LocalLeader>e
function! s:ExecPy()
    lcd %:h
    if executable('python3')
        !python3 %
    elseif executable('python')
        !python %
    endif
endfunction
" command! -buffer Exec call <SID>ExecPy()
nnoremap <silent><buffer> <LocalLeader>e :call <SID>ExecPy()<CR>
nnoremap <silent><buffer> <LocalLeader>x :call <SID>ExecPy()<CR>

" Execute current file (python3 -> python, interactive): <LocalLeader>i
function! s:ExecPy_i()
    lcd %:h
    if executable('python3')
        !python3 -i %
    elseif executable('python')
        !python -i %
    endif
endfunction
nnoremap <silent><buffer> <LocalLeader>i :call <SID>ExecPy_i()<CR>

" Execute current file (python2): <LocalLeader>E
function! s:ExecPy2()
    lcd %:h
    if executable('python')
        !python %
    endif
endfunction
nnoremap <silent><buffer> <LocalLeader>E :call <SID>ExecPy2()<CR>
nnoremap <silent><buffer> <LocalLeader>X :call <SID>ExecPy2()<CR>

" Execute current file (python2, interactive): <LocalLeader>I
function! s:ExecPy2_i()
    lcd %:h
    if executable('python')
        !python -i %
    endif
endfunction
nnoremap <silent><buffer> <LocalLeader>I :call <SID>ExecPy2_i()<CR>
