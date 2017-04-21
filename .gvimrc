""" K.Tahara's gvimrc
" set g:PC_ID home_Windows (0) home_Ubuntu (1) in ~/dotfiles/.vimrc.local

" vb disable must be repeated in _gvimrc
set visualbell t_vb=

""" screen size
if g:PC_ID == 0
    :autocmd GUIEnter * winpos -1620 0
    set lines=54
    set columns=120
    set guifont=Inconsolata:h14:cSHIFTJIS
    "set guifont=Consolas:h11:cSHIFTJIS
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
if g:PC_ID == 0
    if @% == ''
        silent VimwikiIndex
    endif
endif

