""" K.Tahara's vimrc

" set g:PC_ID home_Windows (0) home_Ubuntu (1) in ~/dotfiles/.vimrc.local
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
Plugin 'plasticboy/vim-markdown'
Plugin 'kannokanno/previm'
Plugin 'tyru/open-browser.vim'

" Color scheme
Plugin 'nanotech/jellybeans.vim'
" Plugin 'w0ng/vim-hybrid'
" Plugin 'jnurmine/Zenburn'
" Plugin 'vim-scripts/Wombat'

" Other Utils
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'thinca/vim-fontzoom'
" Plugin 'thinca/vim-quickrun'
Plugin 'scrooloose/nerdcommenter'
Plugin 'vimwiki/vimwiki'
Plugin 'majutsushi/tagbar'
Plugin 'itchyny/lightline.vim'

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
set fileencodings=iso-2022-jp,iso-2022-jp-3,utf-8,cp932,euc-jp,default,latin1

""" Skip loading mswin.vim
"let g:skip_loading_mswin=1

"}}}

""" Indent etc.
syntax on
filetype plugin indent on
set tabstop=8 expandtab shiftwidth=4 softtabstop=4
set foldmethod=marker

"" Python skeleton
autocmd BufNewFile *.py 0r ~/vimfiles/skeleton.py

"" Golang runtimes. These settings are done by default in Kaoriya vim. So skipped on windows.
if ! (has('win32') || has('win64'))
    set rtp+=$GOROOT/misc/vim
    exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")
    exe "set rtp+=" . globpath($GOPATH, "src/github.com/golang/lint/misc/vim")
endif

"" Markdown extension
autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown

"" TeX thing
let g:tex_flavor = "latex"

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
let g:ctrlp_working_path_mode = 'ra'
" let g:ctrlp_max_files = 10000
" let g:ctrlp_clear_cache_on_exit = 0
"}}}

"" Tagbar {{{
nnoremap <silent> <Leader>f :TagbarToggle<CR>
"}}}

"" Lightline{{{
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ }
"}}}

"" jedi-vim{{{
let g:jedi#completions_command = "<C-N>"
let g:jedi#force_py_version = 3
let g:jedi#auto_vim_configuration = 1
"let g:jedi#completions_enabled = 1
" let g:jedi#popup_select_first = 1
let g:jedi#rename_command = "<Leader>R"
"}}}

""" map
inoremap <C-j> <ESC>
nnoremap ; :
nnoremap : ;
nnoremap Y y$
nnoremap <silent> <Leader>cd :cd %:h<CR>:pwd<CR>

""" Testing...
"" enable msys tools
if g:PC_ID == 0
    let $PATH = $PATH . ";C:\\MinGW\\msys\\1.0\\bin"
endif

""" cd ~\ if vim starts without file
if g:PC_ID == 0
    if @% == ''
        cd ~\
    endif
endif

