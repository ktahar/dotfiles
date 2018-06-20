if exists('b:did_ftplugin_c_my')
    finish
endif
let b:did_ftplugin_c_my = 1

" GNU Global
nnoremap <silent><buffer> <Leader>f :Gtags -f %<CR>
nnoremap <buffer> <Leader>g :Gtags -g 
nnoremap <silent><buffer> <Leader>d :GtagsCursor<CR>

