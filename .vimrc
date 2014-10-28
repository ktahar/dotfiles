""" K.Tahara's vimrc
" set g:PC_ID home(0) lab_note(1) lab_WS(2) lab_NV(3)

if filereadable(expand('~/dotfiles/_vimrc.local'))
    source ~/dotfiles/_vimrc.local
elseif filereadable(expand('~/dotfiles/.vimrc.local'))
    source ~/dotfiles/.vimrc.local
endif

""" Neobundle {{{
if has('vim_starting')
    set nocompatible
    set runtimepath+=~/vimfiles/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/vimfiles/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Python
NeoBundle 'davidhalter/jedi-vim'
" NeoBundle 'ivanov/vim-ipython'
" Latex
NeoBundle 'vim-latex', {'type' : 'nosync', 'base' : '~/vimfiles/bundle.nosync'}
" Color
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'jnurmine/Zenburn'
NeoBundle 'vim-scripts/Wombat'
" Other Utils
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'thinca/vim-fontzoom'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'vimwiki/vimwiki'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'itchyny/lightline.vim'
" Neocomplete
NeoBundle 'Shougo/neocomplete.vim'
let vimproc_updcmd = has('win64') ?
      \ 'tools\\update-dll-mingw 64' : 'tools\\update-dll-mingw 32'
execute "NeoBundle 'Shougo/vimproc.vim'," . string({
      \ 'build' : {
      \     'windows' : vimproc_updcmd,
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ })

call neobundle#end()

filetype plugin indent on

NeoBundleCheck
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

""" Plugin 
source $VIMRUNTIME/macros/matchit.vim

"" Vimwiki {{{
if g:PC_ID == 0 || g:PC_ID == 1
    let wiki = {}
    if g:PC_ID == 0
        let wiki.path = '~/OneDrive/docs/vimwiki/'
    else
        let wiki.path = '~/SkyDrive/docs/vimwiki/'
    endif
    let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'c': 'c'}
    let g:vimwiki_list = [wiki]
    let g:vimwiki_camel_case = 0
endif
"}}}

"" CtrlP {{{
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_files = 10000
let g:ctrlp_working_path_mode = 'ra'
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
let g:jedi#force_py_version = 3
"}}}

"" Neocomplete and Jedi {{{
let g:neocomplete#enable_at_startup = 0
let g:jedi#completions_enabled = 1
let g:jedi#auto_vim_configuration = 1
let g:jedi#popup_select_first = 0
let g:jedi#rename_command = "<Leader>R"
if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" Golang setting is done by default.
" let g:neocomplete#sources#omni#input_patterns.go = '[^.[:digit:] *\t]\.\w*'
"}}}

"" Vim-LaTeX{{{
if g:PC_ID == 0 || g:PC_ID == 1
    set shellslash
    set grepprg=grep\ -nH\ $*
    let g:tex_flavor='latex'
    let g:Tex_BibtexFlavor = 'pbibtex -kanji=utf8'
    let g:Tex_CompileRule_dvi = 'platex -kanji=utf8 -no-guess-input-enc -synctex=1 -src-specials -interaction=nonstopmode $*'
    let g:Tex_FormatDependency_pdf = 'dvi,pdf'
    let g:Tex_CompileRule_pdf = 'dvipdfmx $*.dvi'
    let g:Tex_ViewRule_pdf = 'C:/Program Files/SumatraPDF/SumatraPDF.exe -reuse-instance'
endif
if g:PC_ID == 0
    let g:Tex_ViewRule_dvi = 'c:/dviout/dviout.exe -1'
elseif g:PC_ID == 1
    let g:Tex_ViewRule_dvi = 'c:/w32tex/dviout/dviout.exe -1'
endif
" }}}

""" map
nnoremap ; :
nnoremap : ;
nnoremap Y y$
nnoremap <silent> <Leader>cd :cd %:h<CR>:pwd<CR>

""" Testing...
"" enable msys tools
if g:PC_ID == 0 || g:PC_ID == 1 || g:PC_ID == 3
    let $PATH = $PATH . ";C:\\MinGW\\msys\\1.0\\bin"
endif

""" cd ~\ if vim starts without file
if g:PC_ID == 0 || g:PC_ID == 1 || g:PC_ID == 3
    if @% == ''
        cd ~\
    endif
endif

