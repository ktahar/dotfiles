if exists('b:did_ftplugin_ocaml_my')
    finish
endif
let b:did_ftplugin_ocaml_my = 1

packadd merlin
setl fileencoding=utf-8
setl smartindent

nnoremap <LocalLeader>d :<C-u>MerlinTypeOf<CR>
