""" K.Tahara's vimrc
" set g:PC_ID home_Windows (0) home_Linux (1) lab_Windows (2) lab_Linux (3) in ~/dotfiles/.vimrc.local

if filereadable(expand('~/dotfiles/_vimrc.local'))
    source ~/dotfiles/_vimrc.local
elseif filereadable(expand('~/dotfiles/.vimrc.local'))
    source ~/dotfiles/.vimrc.local
endif

""" Vundle {{{
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
if (has('win32') || has('win64'))
    set rtp+=~/vimfiles/bundle/Vundle.vim
    call vundle#begin('$USERPROFILE/vimfiles/bundle/')
else
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
endif

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Python
Plugin 'davidhalter/jedi-vim'
" Plugin 'ivanov/vim-ipython'

" Markdown
"Plugin 'godlygeek/tabular'
"Plugin 'plasticboy/vim-markdown'
Plugin 'kannokanno/previm'
Plugin 'tyru/open-browser.vim'

" Other Utils
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'majutsushi/tagbar'
" Plugin 'thinca/vim-quickrun'
" Plugin 'itchyny/lightline.vim'

" On windows I use gVim.
if (has('win32') || has('win64'))
    Plugin 'thinca/vim-fontzoom'

    " Color scheme
    Plugin 'nanotech/jellybeans.vim'
    " Plugin 'w0ng/vim-hybrid'
    " Plugin 'jnurmine/Zenburn'
    " Plugin 'vim-scripts/Wombat'
endif

if g:PC_ID == 0
    Plugin 'vimwiki/vimwiki'
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"""}}}

""" Basic settings {{{

""" important 
set nocompatible
set noim
set nopaste

""" Back up 
set backup
set backupdir=.,~/tmp
set swapfile
set directory=~/tmp,.
set undofile
set undodir=~/tmp,.

""" UI 
set visualbell t_vb=
set title
set ruler
set number
set wrap
set showtabline=1
"" Status line, command
set laststatus=2
set cmdheight=2
set history=50
set showmode
set showcmd
set wildmenu
set wildmode=list:longest,full

""" Input 
set iminsert=0
set imsearch=0
set backspace=indent,eol,start

""" search 
set wrapscan
set ignorecase
set smartcase
set incsearch
set hlsearch

""" File 
set fileencodings=ucs-bom,utf-8,iso-2022-jp,iso-2022-jp-3,cp932,euc-jp,default,latin1

""" Skip loading mswin.vim
"let g:skip_loading_mswin=1

"}}}

""" Indent etc.
syntax on
filetype plugin indent on
set tabstop=8 expandtab shiftwidth=4 softtabstop=4
set foldmethod=marker

""" Autocmds
"" grep to quickfix
autocmd QuickFixCmdPost *grep* cwindow

"" Python skeleton
if (has('win32') || has('win64'))
    autocmd BufNewFile *.py 0r ~/vimfiles/skeleton.py
else
    autocmd BufNewFile *.py 0r ~/.vim/skeleton.py
endif

"" Markdown extension
autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown

"" Sumo extension
autocmd BufNewFile,BufRead *.{sumocfg} set filetype=xml

"" GridLAB-D extension
autocmd BufNewFile,BufRead *.{glm} set filetype=glm

"" TeX thing
let g:tex_flavor = "latex"

"" ROS extension
autocmd BufNewFile,BufRead *.launch set filetype=xml

"" Binary {{{
" vim -b : edit binary using xxd-format!
augroup Binary
    au!
    au BufReadPre  *.npy let &bin=1
    au BufReadPost *.npy if &bin | %!xxd
    au BufReadPost *.npy set ft=xxd | endif
    au BufWritePre *.npy if &bin | %!xxd -r
    au BufWritePre *.npy endif
    au BufWritePost *.npy if &bin | %!xxd
    au BufWritePost *.npy set nomod | endif
augroup END
"}}}

""" Plugin 
source $VIMRUNTIME/macros/matchit.vim

"" Vimwiki {{{
if g:PC_ID == 0
    let wiki = {}
    let wiki.path = '~/OneDrive/docs/vimwiki/'
    let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'c': 'c'}
    let g:vimwiki_list = [wiki]
    let g:vimwiki_camel_case = 0
endif
"}}}

"" CtrlP {{{
let g:ctrlp_map = '<c-k>'
let g:ctrlp_working_path_mode = 'ra'
" let g:ctrlp_max_files = 10000
" let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_prompt_mappings = {
            \ 'AcceptSelection("t")': ['<c-g>', '<c-t>'],
            \ 'PrtExit()':            ['<esc>', '<c-c>'],
            \ 'PrtHistory(-1)':       ['<c-j>'],
            \ 'PrtHistory(1)':        ['<c-k>'],
            \ 'PrtSelectMove("j")':   ['<c-n>', '<down>'],
            \ 'PrtSelectMove("k")':   ['<c-p>', '<up>'],
            \ }
if executable('ag')
    let g:ctrlp_use_caching = 0
    let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden -g ""'
endif
"}}}

"" Tagbar {{{
nnoremap <silent> <Leader>b :TagbarToggle<CR>
"}}}

"" jedi-vim{{{
let g:jedi#completions_command = "<C-N>"
if g:PC_ID == 0
    let g:jedi#force_py_version = 3
endif
let g:jedi#auto_vim_configuration = 1
" let g:jedi#completions_enabled = 1
" let g:jedi#popup_select_first = 1
let g:jedi#rename_command = "<Leader>R"
"}}}

"" open-browser{{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nnoremap gx <Plug>(openbrowser-smart-search)
vnoremap gx <Plug>(openbrowser-smart-search)
"}}}

""" map
inoremap <C-j> <ESC>
nnoremap ; :
nnoremap : ;
nnoremap Y y$
nnoremap <silent> <Leader>cd :<C-u>cd %:h<CR>:pwd<CR>
nnoremap <C-n> :<C-u>cn<CR>
nnoremap <C-p> :<C-u>cp<CR>

"" grep related
nnoremap <Leader>v :<C-u>vim  `git ls-files`<Home><Right><Right><Right><Right>
if executable('ag')
    set grepprg=ag\ --hidden\ --vimgrep\ $*
    set grepformat=%f:%l:%c:%m
    nnoremap <Leader>a :<C-u>sil gr  `git ls-files`<Home><Right><Right><Right><Right><Right><Right><Right>
endif

""" cd ~\ if vim starts without file
if g:PC_ID == 0 || g:PC_ID == 2
    if @% == ''
        cd ~\
    endif
endif

