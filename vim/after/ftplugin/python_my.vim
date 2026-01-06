if exists('b:did_ftplugin_python_my')
    finish
endif
let b:did_ftplugin_python_my = 1

setl fileencoding=utf-8
setl foldmethod=indent

" LSP
nnoremap <silent><buffer> <LocalLeader>t <plug>(lsp-hover)
nnoremap <silent><buffer> <LocalLeader>d <plug>(lsp-definition)
nnoremap <silent><buffer> <LocalLeader>n <plug>(lsp-document-diagnostics)
nnoremap <silent><buffer> <LocalLeader>r <plug>(lsp-rename)
nnoremap <silent><buffer> <LocalLeader>R <plug>(lsp-references)
nnoremap <silent><buffer> <LocalLeader>S <plug>(lsp-document-symbol)

" map qX for quickfix
silent call ToggleQL(1)

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
