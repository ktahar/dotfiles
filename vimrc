""" ktaha's vimrc

let s:is_win = has('win32') || has('win64')

""" Basic settings {{{

""" important
set nocompatible
set noim
set nopaste
set hidden

""" Back up
set backup
set backupdir=.,~/.local/tmp,~/tmp
set swapfile
set directory=~/.local/tmp,~/tmp,.
set undofile
set undodir=~/.local/tmp,~/tmp,.

""" UI
set visualbell t_vb=
set notitle
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

""" Spell
set nospell
set spelllang=en,cjk

""" fillchar
" vertical split with │ (unicode char U+2502) instead of default |
" fold with ─ (unicode char U+2500) instead of default -
" aiming only Linux terminal.
if !s:is_win && !has("gui_running")
    set fillchars=vert:│,fold:─
endif

set textwidth=0
set formatoptions=jMql
"}}}

""" map {{{
nnoremap <Space> <Nop>
let g:mapleader = "\<Space>"
let g:maplocalleader = "\<Space>"
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q <Nop>

inoremap <C-j> <ESC>
cnoremap <C-j> <C-u><ESC>
nnoremap ; :
nnoremap : ;
nnoremap Y y$
nnoremap <silent> <Leader>cd :<C-u>lcd %:h<CR>:pwd<CR>
nnoremap <silent> <Leader>h :<C-u>noh<CR>
nnoremap <silent> <C-n> :<C-u>cn<CR>
nnoremap <silent> <C-p> :<C-u>cp<CR>
nnoremap <silent> <Leader>q :<C-u>ccl<CR>
nnoremap <silent> <Leader>Q :<C-u>cw<CR>
nnoremap <silent> <Leader>s :<C-u>setl spell!<CR>:setl spell?<CR>
nnoremap <silent> <Leader>m :<C-u>vert rightb term<CR>
nnoremap <silent> <Leader>M :<C-u>rightb term<CR>

"" tmux window selection. cf. vim-tmux-navigation. {{{
function! s:TmuxSocket()
    " The socket path is the first value in the comma-separated list of $TMUX.
    return split($TMUX, ',')[0]
endfunction

function! s:TmuxCommand(args)
    let cmd = 'tmux -S ' . s:TmuxSocket() . ' ' . a:args
    return system(cmd)
endfunction

function! s:TmuxWindow(dir)
    let args = 'select-window -' . a:dir
    silent call s:TmuxCommand(args)
endfunction

if empty($TMUX)
    " unmap to avoid confusing behaviour
    nnoremap <C-k>p <Nop>
    nnoremap <C-k>n <Nop>
    if exists(':terminal')
        tnoremap <C-k>p <Nop>
        tnoremap <C-k>n <Nop>
    endif
else
    command! TmuxWindowPrevious call s:TmuxWindow('p')
    command! TmuxWindowNext call s:TmuxWindow('n')
    nnoremap <silent> <C-k>p :<C-u>TmuxWindowPrevious<CR>
    nnoremap <silent> <C-k>n :<C-u>TmuxWindowNext<CR>
    if exists(':terminal')
        tnoremap <silent> <C-k>p <C-k>:<C-u>TmuxWindowPrevious<CR>
        tnoremap <silent> <C-k>n <C-k>:<C-u>TmuxWindowNext<CR>
    endif
endif
"}}}

if exists(':terminal')
    if exists('+termwinkey')
        set termwinkey=<C-k>
    else
        set termkey=<C-k>
    endif
    tnoremap <C-k><C-J> <C-k>N
    tnoremap <C-k>[ <C-k>N
    tnoremap <C-k><C-[> <C-k>N
    tnoremap <silent> <C-k>h <C-k>:<C-u>TmuxNavigateLeft<CR>
    tnoremap <silent> <C-k>j <C-k>:<C-u>TmuxNavigateDown<CR>
    tnoremap <silent> <C-k>k <C-k>:<C-u>TmuxNavigateUp<CR>
    tnoremap <silent> <C-k>l <C-k>:<C-u>TmuxNavigateRight<CR>
endif
nnoremap <silent> <C-k>h :<C-u>TmuxNavigateLeft<CR>
nnoremap <silent> <C-k>j :<C-u>TmuxNavigateDown<CR>
nnoremap <silent> <C-k>k :<C-u>TmuxNavigateUp<CR>
nnoremap <silent> <C-k>l :<C-u>TmuxNavigateRight<CR>
nnoremap <C-k><C-h> <C-w>H
nnoremap <C-k><C-j> <C-w>J
nnoremap <C-k><C-k> <C-w>K
nnoremap <C-k><C-l> <C-w>L
nnoremap <C-k>H 6<C-w><
nnoremap <C-k>J 3<C-w>+
nnoremap <C-k>K 3<C-w>-
nnoremap <C-k>L 6<C-w>>
nnoremap <silent> <C-k>\ :<C-u>vsp<CR>
nnoremap <silent> <C-k><Bar> :<C-u>vsp<CR>
nnoremap <silent> <C-k>- :<C-u>sp<CR>
nnoremap <C-k> <C-w>

" insert datetime
inoremap <expr> ,df strftime('%Y-%m-%d %H:%M')
inoremap <expr> ,dd strftime('%Y-%m-%d')
inoremap <expr> ,dt strftime('%H:%M')
"" for header of diary
inoremap <expr> ,dh strftime('## %Y-%m-%d')
"}}}

""" Plugin Loading {{{
source $VIMRUNTIME/macros/matchit.vim

let g:no_gvimrc_example = 1
let g:no_vimrc_example  = 1
" Skip loading default plugins
let g:loaded_gzip               = 1
let g:loaded_tar                = 1
let g:loaded_tarPlugin          = 1
let g:loaded_zip                = 1
let g:loaded_zipPlugin          = 1
let g:loaded_rrhelper           = 1
let g:loaded_vimball            = 1
let g:loaded_vimballPlugin      = 1
let g:loaded_getscript          = 1
let g:loaded_getscriptPlugin    = 1
" I use netrw actually
" let g:loaded_netrw              = 1
" let g:loaded_netrwPlugin        = 1
" let g:loaded_netrwSettings      = 1
" let g:loaded_netrwFileHandlers  = 1
let g:did_install_default_menus = 1
let g:skip_loading_mswin        = 1
let g:did_install_syntax_menu   = 1
"}}}

""" Commands (grep, diff etc.) {{{
" sudo write
cabbrev w!! w !sudo tee > /dev/null %

" eiji dictionary
if executable('eiji')
    nnoremap <Leader>w :<C-u>!eiji <cword><CR>
endif

function! s:get_git_root()
    let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
    return v:shell_error ? '' : root
endfunction

"" grep
if executable('ag')
    set grepprg=ag\ --vimgrep\ $*
    set grepformat=%f:%l:%c:%m
endif

function! s:git_vimgrep(pattern)
    let root = s:get_git_root()
    if empty(root)
        echo "Not in git repository"
        return
    endif
    let l:fls = substitute(system('git ls-files ' . root), '\n', ' ', 'g')
    execute 'silent vimgrep' a:pattern l:fls
endfunction
command -nargs=1 GitVim call s:git_vimgrep(<f-args>)
nnoremap <Leader>V :<C-u>GitVim<Space>

function! s:git_grep(pattern)
    let root = s:get_git_root()
    if empty(root)
        echo "Not in git repository"
        return
    endif
    let l:fls = substitute(system('git ls-files ' . root), '\n', ' ', 'g')
    execute 'silent grep' a:pattern l:fls
endfunction
command -nargs=1 GitGrep call s:git_grep(<f-args>)
nnoremap <Leader>v :<C-u>GitGrep<Space>

function! s:make_ctags()
    execute 'silent! !ctags -R'
    redraw!
endfunction
command MakeCtags call s:make_ctags()
nnoremap <Leader>T :<C-u>MakeCtags<CR>

"" grep to quickfix
autocmd QuickFixCmdPost *grep* cwindow

"" DiffOrig from vimrc_example.vim
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif
"}}}

""" Fileformat and Filetype {{{
filetype plugin indent on
syntax on
set tabstop=4 expandtab shiftwidth=4 softtabstop=4
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

"" OCaml
" prevent maps by default ocaml.vim and merlin.vim
let no_ocaml_maps = 1
let g:merlin_disable_default_keybindings = 1
autocmd BufNewFile,BufRead ocamlinit* set filetype=ocaml
autocmd BufNewFile,BufRead dune set filetype=dune

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
    elseif ($TERM == "gnome-256color") || ($TERM == "xterm-256color") || ($TERM == "rxvt-unicode-256color")
        let &t_SI = "\<Esc>[6 q"
        let &t_SR = "\<Esc>[4 q"
        let &t_EI = "\<Esc>[2 q"
    endif
endif

"" Linux Input Methods {{{
if executable('ibus')
    " let g:input_toggle = 0
    function! DeactivateIbusMozc()
        let g:input_status = system('ibus engine')
        if g:input_status =~ '^mozc-jp'
            " let g:input_toggle = 1
            let l:a = system('ibus engine xkb:us::eng')
        endif
    endfunction
    function! ActivateIbusMozc()
        let g:input_status = system('ibus engine')
        if g:input_status !~ '^mozc-jp' " && g:input_toggle == 1
            let l:a = system('ibus engine mozc-jp')
            " let g:input_toggle = 0
        endif
    endfunction

    autocmd InsertLeave * call DeactivateIbusMozc()
    autocmd InsertEnter * call ActivateIbusMozc()
endif
"}}}
"}}}

""" Plugin Settings {{{
"" vim-lsp {{{
" diagnostic option
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')
let g:lsp_preview_doubletap = 0

if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
       \ 'name': 'pyls',
       \ 'cmd': {server_info->['pyls']},
       \ 'whitelist': ['python'],
       \ 'workspace_config': {'pyls': {'plugins': {'pycodestyle': {'enabled': v:false}}}},
       \ })
    " au FileType python setl omnifunc=lsp#complete
endif
if executable('clangd-6.0')
    " sudo apt install clang-tools-6.0
    au User lsp_setup call lsp#register_server({
       \ 'name': 'clangd-6.0',
       \ 'cmd': {server_info->['clangd-6.0']},
       \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
       \ })
endif
if executable('ocaml-language-server')
    " npm install -g ocaml-language-server
    au User lsp_setup call lsp#register_server({
       \ 'name': 'ocaml-language-server',
       \ 'cmd': {server_info->[&shell, &shellcmdflag, 'ocaml-language-server --stdio']},
       \ 'whitelist': ['ocaml'],
       \ })
endif

au User asyncomplete_setup call asyncomplete#register_source({
    \ 'name': 'omni',
    \ 'whitelist': ['tex'],
    \ 'blacklist': ['c', 'cpp', 'ocaml', 'python'],
    \ 'completor': function('asyncomplete#sources#omni#completor')
    \  })
"}}}

"" fzf {{{
let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-g': 'split',
    \ 'ctrl-v': 'vsplit' }

" utils
function! s:shortpath(path)
    let short = fnamemodify(a:path, ':~:.')
    if !has('win32unix')
        let short = pathshorten(short)
    endif
    let slash = (s:is_win && !&shellslash) ? '\' : '/'
    return empty(short) ? '~'.slash : short . (short =~ escape(slash, '\').'$' ? '' : slash)
endfunction

" file searcher. (ref. ~/.fzf/plugin/fzf.vim)
" if inside git repository, search from project root.
" if not, use default FZF behaviour (search from current).
function! s:fzf_file(bang, ...) abort
    let l:hidden = get(a:, 1, 0)
    let l:root = s:get_git_root()
    let l:opts = {}
    if hidden
        let l:opts.source = 'ag --nocolor --nogroup --hidden -g ""'
    endif
    if empty(l:root)
        let l:prompt = s:shortpath(getcwd())
    else
        let l:opts.dir = l:root
        let l:prompt = s:shortpath(l:opts.dir)
    endif
    let l:opts.options = ['--prompt', l:prompt]
    call fzf#run(fzf#wrap('file', l:opts, a:bang))
endfunction
command! -nargs=? -bang FZFfile call s:fzf_file(<bang>0, <f-args>)
nnoremap <c-j> :<C-u>FZFfile<CR>
nnoremap <c-h> :<C-u>FZFfile 1<CR>

" buffer search (using fzf.vim)
nnoremap <Leader>j :<C-u>Buffers<CR>
" grep and fuzzy search  (using fzf.vim)
nnoremap <Leader>a :<C-u>Ag<space>
"}}}

"" snipmate {{{
imap <C-f> <Esc>a<Plug>snipMateNextOrTrigger
smap <C-f> <Plug>snipMateNextOrTrigger
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
" let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gb <Plug>(openbrowser-smart-search)
vmap gb <Plug>(openbrowser-smart-search)
"}}}

"" vim-grammarous {{{
let g:grammarous#show_first_error = 1
" let g:grammarous#use_location_list = 1
let g:grammarous#hooks = {}
function! g:grammarous#hooks.on_check(errs) abort
    nmap <buffer><C-n> <Plug>(grammarous-move-to-next-error)
    nmap <buffer><C-p> <Plug>(grammarous-move-to-previous-error)
endfunction

function! g:grammarous#hooks.on_reset(errs) abort
    nnoremap <buffer><C-n> :<C-u>cn<CR>
    nnoremap <buffer><C-p> :<C-u>cp<CR>
endfunction
"}}}

"" tmux-navigator {{{
let g:tmux_navigator_no_mappings = 1
"}}}

"" vim-markdown {{{
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_folding_level = 3
"}}}

"" vimtex {{{
let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_view_method = 'zathura'
"}}}
"}}}

""" Colorscheme {{{
silent! colorscheme jellybeans
"}}}
