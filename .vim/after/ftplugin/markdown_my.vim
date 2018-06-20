if exists('b:did_ftplugin_markdown_my')
    finish
endif
let b:did_ftplugin_markdown_my = 1

setl fileencoding=utf-8
setl tabstop=8 expandtab shiftwidth=4 softtabstop=4
setl smartindent

" Open browser preview by Previm \e
nnoremap <silent><buffer> <LocalLeader>e :PrevimOpen<CR>

" Convert to html by pandoc \E
function! s:PandocHTML()
    " cd %:h
    !pandoc -o %:r.html %
endfunction
" command! -buffer Exec call <SID>PandocHTML()
nnoremap <silent><buffer> <Leader>E :call <SID>PandocHTML()<CR>

