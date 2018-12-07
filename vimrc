""" ktaha's vimrc

if filereadable(expand('~/dotfiles/vimrc.local'))
    source ~/dotfiles/vimrc.local
endif

let s:is_win = has('win32') || has('win64')

""" Vundle {{{
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
if s:is_win
    set rtp+=~/vimfiles/bundle/Vundle.vim
    call vundle#begin('$USERPROFILE/vimfiles/bundle/')
else
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
endif

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Completion
Plugin 'Valloric/YouCompleteMe'
" Plugin 'davidhalter/jedi-vim'

" Markdown
"Plugin 'godlygeek/tabular'
"Plugin 'plasticboy/vim-markdown'
"Plugin 'mzlogin/vim-markdown-toc'
Plugin 'previm/previm'
Plugin 'tyru/open-browser.vim'

" Snippets
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'

" Other Utils
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-obsession'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'ryanoasis/vim-devicons'
" Plugin 'ctrlpvim/ctrlp.vim'
" Plugin 'itchyny/lightline.vim'
" Plugin 'thinca/vim-quickrun'

" On windows I use gVim.
if s:is_win
    Plugin 'thinca/vim-fontzoom'

    " Color scheme
    Plugin 'nanotech/jellybeans.vim'
    " Plugin 'w0ng/vim-hybrid'
    " Plugin 'jnurmine/Zenburn'
    " Plugin 'vim-scripts/Wombat'
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
set hidden

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
set noruler
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
set statusline=[%<%{fnamemodify(getcwd(),':~')}]\ %f\ %h%m%r%w%=%y\ %{&fenc}\ %{&ff}\ %12.(%l/%L,%)%3.v

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

""" Highlights
highlight StatusLine cterm=NONE ctermfg=0 ctermbg=2
highlight StatusLineNC cterm=NONE ctermfg=2 ctermbg=0
highlight Search ctermfg=0 ctermbg=11
highlight Folded ctermfg=4 ctermbg=8
"}}}

""" map{{{
nnoremap <Space> <Nop>
let mapleader = "\<Space>"
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q <Nop>

inoremap <C-j> <ESC>
nnoremap ; :
nnoremap : ;
nnoremap Y y$
nnoremap <silent> <Leader>cd :<C-u>lcd %:h<CR>:pwd<CR>
nnoremap <silent> <Leader>h :<C-u>noh<CR>
nnoremap <C-n> :<C-u>cn<CR>
nnoremap <C-p> :<C-u>cp<CR>

nnoremap s <Nop>
nnoremap sh <C-W>h
nnoremap sj <C-W>j
nnoremap sk <C-W>k
nnoremap sl <C-W>l
nnoremap s<C-h> <C-W>H
nnoremap s<C-j> <C-W>J
nnoremap s<C-k> <C-W>K
nnoremap s<C-l> <C-W>L
nnoremap sH 6<C-W><
nnoremap sJ 3<C-W>+
nnoremap sK 3<C-W>-
nnoremap sL 6<C-W>>
nnoremap so <C-W>o
nnoremap sc <C-W>c
nnoremap <silent> s\ :<C-u>vsp<CR>
nnoremap <silent> s<Bar> :<C-u>vsp<CR>
nnoremap <silent> s- :<C-u>sp<CR>
nnoremap sn gt
nnoremap sp gT
"}}}

""" Commands (grep, diff etc.) {{{
"" grep related (TODO: define function etc.?)
nnoremap <Leader>v :<C-u>vim  `git ls-files`<Home><Right><Right><Right><Right>
if executable('ag')
    set grepprg=ag\ --vimgrep\ $*
    set grepformat=%f:%l:%c:%m
    nnoremap <Leader>a :<C-u>sil gr  `git ls-files`<Home><Right><Right><Right><Right><Right><Right><Right>
endif

"" DiffOrig from vimrc_example.vim
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

"" grep to quickfix
autocmd QuickFixCmdPost *grep* cwindow

"}}}

""" Fileformat and Filetype {{{
syntax on
filetype plugin indent on
set tabstop=8 expandtab shiftwidth=4 softtabstop=4
set foldmethod=marker

"" Python skeleton
if s:is_win
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
"}}}

""" Terminal specific {{{
""" Cursor
if has("unix")
    if $TERM == "screen-256color"
        let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>[6 q\<Esc>\\"
        let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>[4 q\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>[2 q\<Esc>\\"
    elseif ($TERM == "gnome-256color") || ($TERM == "xterm-256color")
        let &t_SI = "\<Esc>[6 q"
        let &t_SR = "\<Esc>[4 q"
        let &t_EI = "\<Esc>[2 q"
    endif
endif

"" Linux Input Methods {{{
if executable('fcitx-remote')
    let g:input_toggle = 0
    function! DeactivateFcitx()
        let s:input_status = system('fcitx-remote')
        if s:input_status == 2
            let g:input_toggle = 1
            let l:a = system('fcitx-remote -c')
        endif
    endfunction
    function! ActivateFcitx()
        let s:input_status = system('fcitx-remote')
        if s:input_status != 2 && g:input_toggle == 1
            let l:a = system('fcitx-remote -o')
            let g:input_toggle = 0
        endif
    endfunction

    autocmd InsertLeave * call DeactivateFcitx()
    autocmd InsertEnter * call ActivateFcitx()

elseif executable('ibus')
    let g:input_toggle = 0
    function! DeactivateIbusMozc()
        let g:input_status = system('ibus engine')
        if g:input_status =~ '^mozc-jp'
            let g:input_toggle = 1
            let l:a = system('ibus engine xkb:us::eng')
        endif
    endfunction
    function! ActivateIbusMozc()
        let g:input_status = system('ibus engine')
        if g:input_status !~ '^mozc-jp' && g:input_toggle == 1
            let l:a = system('ibus engine mozc-jp')
            let g:input_toggle = 0
        endif
    endfunction

    autocmd InsertLeave * call DeactivateIbusMozc()
    autocmd InsertEnter * call ActivateIbusMozc()
endif
"}}}
"}}}

""" Plugins {{{
source $VIMRUNTIME/macros/matchit.vim

"" YouCompleteMe {{{
let g:ycm_global_ycm_extra_conf = '~/dotfiles/ycm_extra_conf.py'
highlight YcmErrorSign ctermfg=15 ctermbg=1
highlight YcmErrorSection ctermfg=15 ctermbg=1
"}}}

"" fzf {{{
set rtp+=~/.fzf
let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-g': 'split',
    \ 'ctrl-v': 'vsplit' }

" file search (see ~/.fzf/plugin/fzf.vim)
function! s:shortpath()
    let short = fnamemodify(getcwd(), ':~:.')
    if !has('win32unix')
        let short = pathshorten(short)
    endif
    let slash = (s:is_win && !&shellslash) ? '\' : '/'
    return empty(short) ? '~'.slash : short . (short =~ escape(slash, '\').'$' ? '' : slash)
endfunction
function! s:get_git_root()
    let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
    return v:shell_error ? '' : root
endfunction
function! s:fzf_file(bang, ...) abort
    let hidden = get(a:, 1, 0)
    let root = s:get_git_root()
    let opts = {}
    if hidden
        let opts.source = 'ag --nocolor --nogroup --hidden -g ""'
    endif
    if empty(root)
        let prompt = s:shortpath()
    else
        let opts.dir = root
        let slash = (s:is_win && !&shellslash) ? '\' : '/'
        let prompt = opts.dir . slash
    endif
    let opts.options = ['--prompt', prompt]
    call fzf#run(fzf#wrap('file', opts, a:bang))
endfunction
command! -nargs=? -bang FZFfile call s:fzf_file(<bang>0, <f-args>)
nnoremap <c-j> :<C-u>FZFfile<CR>
nnoremap <c-h> :<C-u>FZFfile 1<CR>

" buffer search
function! s:fzf_buffer(bang) abort
    call fzf#run(fzf#wrap('buffer',
            \ {'source': map(range(1, bufnr('$')), 'bufname(v:val)'),
            \ 'options': ['--prompt', 'buf> ']
            \ }, a:bang))
endfunction
command! -bang FZFbuf call s:fzf_buffer(<bang>0)
nnoremap <Leader>j :<C-u>FZFbuf<CR>
"}}}

"" CtrlP {{{
"let g:ctrlp_map = '<c-j>'
"let g:ctrlp_working_path_mode = 'ra'
"let g:ctrlp_lazy_update = 1
"let g:ctrlp_prompt_mappings = {
            "\ 'AcceptSelection("t")': ['<c-t>'],
            "\ 'AcceptSelection("h")': ['<c-g>'],
            "\ 'AcceptSelection("v")': ['<c-v>'],
            "\ 'PrtExit()':            ['<esc>', '<c-c>', '<c-j>'],
            "\ 'PrtSelectMove("j")':   ['<c-n>', '<down>'],
            "\ 'PrtSelectMove("k")':   ['<c-p>', '<up>'],
            "\ 'PrtHistory(-1)':       ['<down>'],
            "\ 'PrtHistory(1)':        ['<up>'],
            "\ }
"if executable('ag')
    "let g:ctrlp_regexp = 1
    "let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup -g ""'
"endif
"let g:ctrlp_use_caching = 1
"let g:ctrlp_clear_cache_on_exit = 0
"nnoremap <Leader>j :<C-u>CtrlPBuffer<CR>
"}}}

"" snipmate {{{
imap <C-f> <Esc>a<Plug>snipMateNextOrTrigger
smap <C-f> <Plug>snipMateNextOrTrigger
"}}}

"" NERDTree {{{
nnoremap <Leader>t :<C-u>NERDTreeToggle<CR>
"}}}

"" Tagbar {{{
nnoremap <silent> <Leader>b :<C-u>TagbarToggle<CR>
let g:tagbar_map_togglesort = "r"
let g:tagbar_sort = 0
let g:tagbar_type_tex = {
            \ 'ctagstype' : 'latex',
            \ 'kinds' : [
            \ 'l:labels',
            \ 'c:chapters',
            \ 's:sections',
            \ 't:subsections',
            \ 'u:subsubsections',
            \]
            \ }
"}}}

"" open-browser {{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
"}}}

"}}}

