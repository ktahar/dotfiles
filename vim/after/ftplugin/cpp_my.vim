if exists('b:did_ftplugin_cpp_my')
    finish
endif
let b:did_ftplugin_cpp_my = 1

setl foldmethod=syntax

" LSP mappings
nnoremap <silent><buffer> <LocalLeader>t :<C-u>LspHover<CR>
nnoremap <silent><buffer> <LocalLeader>d :<C-u>LspDefinition<CR>
nnoremap <silent><buffer> <LocalLeader>n :<C-u>LspDocumentDiagnostics<CR>
nnoremap <silent><buffer> <LocalLeader>r :<C-u>LspRename<CR>

" GNU Global
nnoremap <silent><buffer> <LocalLeader>a :<C-u>Gtags -f %<CR>
nnoremap <buffer> <LocalLeader>g :<C-u>Gtags -g
nnoremap <silent><buffer> <LocalLeader>c :<C-u>GtagsCursor<CR>
