if exists('b:did_ftplugin_ocaml_my')
    finish
endif
let b:did_ftplugin_ocaml_my = 1

setl fileencoding=utf-8

nnoremap <LocalLeader>d :<C-u>MerlinTypeOf<CR>

function! s:ocaml_fmt()
    let now_line = line('.')
    exec ':%! ocp-indent'
    exec ':' .. now_line
endfunction

augroup ocaml_fmt
    autocmd!
    autocmd BufWrite,FileWritePre,FileAppendPre *.mli\= call s:ocaml_fmt()
augroup END
