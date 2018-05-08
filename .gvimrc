""" K.Tahara's gvimrc
" set g:PC_ID other (0) home_Windows (1) lab_Windows (2) in ~/dotfiles/.vimrc.local

" vb disable must be repeated in _gvimrc
set visualbell t_vb=

""" screen size and fonts
if g:PC_ID == 1
    :autocmd GUIEnter * winpos -1620 0
    set lines=54
    set columns=120
    set guifont=Cica:h14:cSHIFTJIS
    set guifontwide=MS_Gothic:h12:cSHIFTJIS
elseif g:PC_ID == 2
    :autocmd GUIEnter * winpos 250 0
    set lines=54
    set columns=120
    set guifont=Cica:h14:cSHIFTJIS
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
nnoremap <M-n> :simalt ~n<CR>
endif

""" colorscheme
colorscheme jellybeans

