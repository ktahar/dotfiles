""" K.Tahara's gvimrc
" set g:PC_ID home(0) lab_note(1) lab_WS(2) lab_NV(3)

" vb disable must be repeated in _gvimrc
set visualbell t_vb=

""" screen size
if g:PC_ID == 0
    :autocmd GUIEnter * winpos 166 0
    set lines=56
    set columns=80
    set guifont=Consolas:h11:cSHIFTJIS
    set guifontwide=MS_Gothic:h12:cSHIFTJIS
elseif g:PC_ID == 1
    :autocmd GUIEnter * winpos 136 0
    set lines=40
    set columns=80
    set guifont=Consolas:h11:cSHIFTJIS
    set guifontwide=MS_Gothic:h12:cSHIFTJIS
elseif g:PC_ID == 3
    :autocmd GUIEnter * winpos 136 0
    set lines=56
    set columns=120
    set guifont=Inconsolata:h13:cSHIFTJIS
    set guifontwide=MS_Gothic:h12:cSHIFTJIS
endif

""" cursor blink off
set guicursor=a:blinkon0

""" mouse
set mouse=a
set nomousefocus
set mousehide

""" JP GUI
set linespace=0
" set guioptions+=M
set guioptions-=g
set guioptions-=m
set guioptions-=t
set guioptions-=T
set guioptions-=e

""" transparency
if has("win32") || has("win64")
    autocmd guienter * set transparency=240
    autocmd FocusGained * set transparency=240
    autocmd FocusLost * set transparency=220
endif

""" maps

"" GUI Window Maximize, redo
if has("win32") || has("win64")
nnoremap <M-x> :simalt ~x<CR>
nnoremap <M-r> :simalt ~r<CR>
endif

""" colorscheme
colorscheme jellybeans

"" indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

""" open vimwiki if vim starts without file
if g:PC_ID == 0 || g:PC_ID == 1
    if @% == ''
        silent VimwikiIndex
    endif
endif

