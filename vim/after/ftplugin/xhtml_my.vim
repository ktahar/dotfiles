if exists('b:did_ftplugin_xhtml_my')
    finish
endif
let b:did_ftplugin_xhtml_my = 1

setl fileencoding=utf-8
setl tabstop=2 expandtab shiftwidth=2 softtabstop=2

if (has('win32') || has('win64'))
    nnoremap <silent><buffer> <Leader>r :!start cmd /c "%"<CR>
endif

