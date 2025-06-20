if exists('b:did_ftplugin_ocaml_my')
    finish
endif
let b:did_ftplugin_ocaml_my = 1

setl fileencoding=utf-8
setl tabstop=8 expandtab shiftwidth=2 softtabstop=2

" LSP
" NOTE: I don't understand what these are for now
nnoremap <silent><buffer> <LocalLeader>h :<C-u>MerlinShrinkEnclosing<CR>
nnoremap <silent><buffer> <LocalLeader>l :<C-u>MerlinGrowEnclosing<CR>

nnoremap <silent><buffer> <LocalLeader>g :<C-u>MerlinTypeOf<CR>
nnoremap <silent><buffer> <LocalLeader>t <plug>(lsp-hover)
nnoremap <silent><buffer> <LocalLeader>d <plug>(lsp-definition)
nnoremap <silent><buffer> <LocalLeader>n <plug>(lsp-document-diagnostics)
nnoremap <silent><buffer> <LocalLeader>r <plug>(lsp-rename)

" overwrite :cnext and :cprevious
nnoremap <silent><buffer> <C-n> :<C-u>lnext<CR>
nnoremap <silent><buffer> <C-p> :<C-u>lprevious<CR>

" Execute current file as a script <LocalLeader>e
function! s:ExecOcaml()
    lcd %:h
    if executable('ocaml')
        !ocaml %
    endif
endfunction
" command! -buffer Exec call <SID>ExecOcaml()
nnoremap <silent><buffer> <LocalLeader>e :call <SID>ExecOcaml()<CR>
