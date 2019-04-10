if exists('b:did_ftplugin_ocaml_my')
    finish
endif
let b:did_ftplugin_ocaml_my = 1

setl fileencoding=utf-8

nnoremap <LocalLeader>d :<C-u>MerlinTypeOf<CR>
