if exists('b:did_ftplugin_c_my')
    finish
endif
let b:did_ftplugin_c_my = 1

" GNU Global
nnoremap <silent><buffer> <LocalLeader>f :Gtags -f %<CR>
nnoremap <buffer> <LocalLeader>g :Gtags -g 
nnoremap <silent><buffer> <LocalLeader>d :GtagsCursor<CR>

