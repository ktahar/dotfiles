if exists('b:did_ftplugin_c_my')
    finish
endif
let b:did_ftplugin_c_my = 1

" LSP mappings
nnoremap <Leader>d :<C-u>LspDefinition<CR>
nnoremap <Leader>n :<C-u>LspDocumentDiagnostics<CR>

" GNU Global
nnoremap <silent><buffer> <Leader>f :<C-u>Gtags -f %<CR>
nnoremap <buffer> <Leader>g :<C-u>Gtags -g
nnoremap <silent><buffer> <Leader>c :<C-u>GtagsCursor<CR>

