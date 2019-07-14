if exists('b:did_ftplugin_ocaml_my')
    finish
endif
let b:did_ftplugin_ocaml_my = 1

setl fileencoding=utf-8
setl tabstop=8 expandtab shiftwidth=2 softtabstop=2

nnoremap <LocalLeader>f :<C-u>MerlinTypeOf<CR>
nnoremap <LocalLeader>d :<C-u>LspDefinition<CR>
nnoremap <LocalLeader>n :<C-u>LspDocumentDiagnostics<CR>

function! s:ocaml_fmt()
    let now_line = line('.')
    exec ':%! ocp-indent'
    exec ':' .. now_line
endfunction

augroup ocaml_fmt
    autocmd!
    autocmd BufWrite,FileWritePre,FileAppendPre *.mli\= call s:ocaml_fmt()
augroup END

" Execute current file as a script <Leader>e
function! s:ExecOcaml()
    lcd %:h
    if executable('ocaml')
        !ocaml %
    endif
endfunction
" command! -buffer Exec call <SID>ExecOcaml()
nnoremap <silent><buffer> <Leader>e :call <SID>ExecOcaml()<CR>
