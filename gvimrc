" ktaha's gvimrc

let s:is_win = has('win32') || has('win64')

" vb disable must be repeated in _gvimrc
set visualbell t_vb=

""" screen size and fonts
if s:is_win
    set guifont=Cica:h14:cSHIFTJIS
    set guifontwide=MS_Gothic:h12:cSHIFTJIS
elseif has('unix')
    set guifont=Cica\ 14
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

""" windows specific settings
if s:is_win
    "" transparency
    autocmd guienter * set transparency=240
    autocmd FocusGained * set transparency=240
    autocmd FocusLost * set transparency=220

    "" GUI Window Maximize, redo
    nnoremap <M-x> :simalt ~x<CR>
    nnoremap <M-r> :simalt ~r<CR>
    nnoremap <M-n> :simalt ~n<CR>

endif

colorscheme jellybeans
