if exists('b:did_ftplugin_c_my')
    finish
endif
let b:did_ftplugin_c_my = 1

" LSP mappings
nnoremap <buffer> <LocalLeader>d :<C-u>LspDefinition<CR>
nnoremap <buffer> <LocalLeader>n :<C-u>LspDocumentDiagnostics<CR>

" GNU Global
nnoremap <silent><buffer> <LocalLeader>f :<C-u>Gtags -f %<CR>
nnoremap <buffer> <LocalLeader>g :<C-u>Gtags -g
nnoremap <silent><buffer> <LocalLeader>c :<C-u>GtagsCursor<CR>
