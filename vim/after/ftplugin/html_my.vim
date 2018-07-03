if exists('b:did_ftplugin_html_my')
    finish
endif
let b:did_ftplugin_html_my = 1

setl fileencoding=utf-8
setl tabstop=2 expandtab shiftwidth=2 softtabstop=2
nnoremap <silent><buffer> <Leader>r :!start cmd /c "%"<CR>

