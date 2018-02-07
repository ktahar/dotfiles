if exists('b:did_ftplugin_cpp_my')
    finish
endif
let b:did_ftplugin_cpp_my = 1

" GNU Global
nnoremap <silent><buffer> <LocalLeader>f :Gtags -f %<CR>
nnoremap <buffer> <LocalLeader>g :Gtags -g 
nnoremap <silent><buffer> <LocalLeader>d :GtagsCursor<CR>

