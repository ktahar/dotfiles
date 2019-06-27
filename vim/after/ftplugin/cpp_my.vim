if exists('b:did_ftplugin_cpp_my')
    finish
endif
let b:did_ftplugin_cpp_my = 1

" LSP mappings
nnoremap <Leader>d :<C-u>LspDefinition<CR>
nnoremap <Leader>h :<C-u>LspDocumentDiagnostics<CR>

" GNU Global
nnoremap <silent><buffer> <Leader>f :<C-u>Gtags -f %<CR>
nnoremap <buffer> <Leader>g :<C-u>Gtags -g
nnoremap <silent><buffer> <Leader>c :<C-u>GtagsCursor<CR>

