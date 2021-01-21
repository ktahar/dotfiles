if exists('b:did_ftplugin_tex_my')
    finish
endif
let b:did_ftplugin_tex_my = 1

setl fileencoding=utf-8
setl tabstop=2 expandtab shiftwidth=2 softtabstop=2

" override TagbarToggle
nnoremap <silent> <Leader>b :<C-u>VimtexTocToggle<CR>

" Tabularize the tabular
if exists(':AddTabularPattern')
    AddTabularPattern texc /\(&\|\\\\\)/c1
    AddTabularPattern texl /\(&\|\\\\\)/l1
    AddTabularPattern texr /\(&\|\\\\\)/r1

    vnoremap <silent> <Leader>tt :Tabularize texc<CR>
    vnoremap <silent> <Leader>tc :Tabularize texc<CR>
    vnoremap <silent> <Leader>tl :Tabularize texl<CR>
    vnoremap <silent> <Leader>tr :Tabularize texr<CR>
endif

" map for location list
silent call ToggleQL(1)
