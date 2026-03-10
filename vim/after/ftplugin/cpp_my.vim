if exists('b:did_ftplugin_cpp_my')
    finish
endif
let b:did_ftplugin_cpp_my = 1

setl foldmethod=syntax

" LSP mappings
nnoremap <silent><buffer> <LocalLeader>t <plug>(lsp-hover)
nnoremap <silent><buffer> <LocalLeader>d <plug>(lsp-definition)
nnoremap <silent><buffer> <LocalLeader>n <plug>(lsp-document-diagnostics)
nnoremap <silent><buffer> <LocalLeader>r <plug>(lsp-rename)
