if exists('b:did_ftplugin_c_my')
    finish
endif
let b:did_ftplugin_c_my = 1

setl foldmethod=syntax

" LSP mappings
nnoremap <silent><buffer> <LocalLeader>t <plug>(lsp-hover)
nnoremap <silent><buffer> <LocalLeader>d <plug>(lsp-definition)
nnoremap <silent><buffer> <LocalLeader>n <plug>(lsp-document-diagnostics)
nnoremap <silent><buffer> <LocalLeader>r <plug>(lsp-rename)

" GNU Global
" nnoremap <silent><buffer> <LocalLeader>a :<C-u>Gtags -f %<CR>
" nnoremap <buffer> <LocalLeader>g :<C-u>Gtags -g
" nnoremap <silent><buffer> <LocalLeader>c :<C-u>GtagsCursor<CR>
