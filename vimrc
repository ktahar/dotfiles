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

""" Encoding
set encoding=utf-8
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
if has("patch-8.2.0860")
    set nrformats+=unsigned
endif
"}}}

""" map {{{
nnoremap <Space> <Nop>
let g:mapleader = "\<Space>"
let g:maplocalleader = "\<Space>"
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" macro recording starts with Q (instead of q)
nnoremap Q q
nnoremap q <Nop>

function! ToggleQL (force_quickfix)
    if (a:force_quickfix || !g:mapping_quickfix)
        let g:mapping_quickfix = 1
        nnoremap <silent> <C-n> :<C-u>cnext<CR>
        nnoremap <silent> <C-p> :<C-u>cprev<CR>
        nnoremap qn :<C-u>cnext<CR>
        nnoremap qp :<C-u>cprev<CR>
        nnoremap qN :<C-u>clast<CR>
        nnoremap qP :<C-u>cfirst<CR>
        nnoremap qf :<C-u>cnfile<CR>
        nnoremap qF :<C-u>cpfile<CR>
        nnoremap qq :<C-u>cc<CR>
        nnoremap qo :<C-u>copen<CR>
        nnoremap qc :<C-u>cclose<CR>
        nnoremap ql :<C-u>clist<CR>
        nnoremap qw :<C-u>cwindow<CR>
        echo "quickfix"
    else
        let g:mapping_quickfix = 0
        nnoremap <silent> <C-n> :<C-u>lnext<CR>
        nnoremap <silent> <C-p> :<C-u>lprev<CR>
        nnoremap qn :<C-u>lnext<CR>
        nnoremap qp :<C-u>lprev<CR>
        nnoremap qN :<C-u>llast<CR>
        nnoremap qP :<C-u>lfirst<CR>
        nnoremap qf :<C-u>lnfile<CR>
        nnoremap qF :<C-u>lpfile<CR>
        nnoremap qq :<C-u>ll<CR>
        nnoremap qo :<C-u>lopen<CR>
        nnoremap qc :<C-u>lclose<CR>
        nnoremap ql :<C-u>llist<CR>
        nnoremap qw :<C-u>lwindow<CR>
        echo "location"
    endif
endfunction
let g:mapping_quickfix = 1
" start with location mode
silent call ToggleQL(0)
command! ToggleQL call ToggleQL(0)
nnoremap <silent> <Leader>q :<C-u>ToggleQL<CR>

inoremap <C-j> <ESC>
cnoremap <C-j> <C-u><ESC>
nnoremap ; :
nnoremap : ;
nnoremap Y y$
nnoremap <silent> <Leader>cd :<C-u>lcd %:h<CR>:pwd<CR>
nnoremap <silent> <Leader>h :<C-u>noh<CR>
nnoremap <silent> <Leader>s :<C-u>setl spell!<CR>:setl spell?<CR>
nnoremap <silent> <Leader>m :<C-u>vert rightb term<CR>
nnoremap <silent> <Leader>M :<C-u>rightb term<CR>

if exists(':terminal')
    if exists('+termwinkey')
        set termwinkey=<C-k>
    else
        set termkey=<C-k>
    endif
    tnoremap <C-k><C-J> <C-k>N
    tnoremap <C-k>[ <C-k>N
    tnoremap <C-k><C-[> <C-k>N
endif
nnoremap <C-k><C-h> <C-w>H
nnoremap <C-k><C-j> <C-w>J
nnoremap <C-k><C-k> <C-w>K
nnoremap <C-k><C-l> <C-w>L
nnoremap <C-k>H <C-w><
nnoremap <C-k>J <C-w>+
nnoremap <C-k>K <C-w>-
nnoremap <C-k>L <C-w>>
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
autocmd BufNewFile,BufRead dune* set filetype=dune
" temp. disable on windows
if !s:is_win
    let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
    execute "set rtp+=" . g:opamshare . "/merlin/vim"
endif

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
" let g:lsp_preview_doubletap = 0
let g:lsp_diagnostics_virtual_text_enabled = 0
nnoremap <buffer> <expr><Down> lsp#scroll(+4)
nnoremap <buffer> <expr><Up> lsp#scroll(-4)

if executable('pylsp')
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
       \ 'name': 'pylsp',
       \ 'cmd': {server_info->['pylsp']},
       \ 'allowlist': ['python'],
       \ 'workspace_config': {'pylsp': {'plugins': {'pycodestyle':
       \ {'enabled': v:false}}
       \ }},
       \ })
    " au FileType python setl omnifunc=lsp#complete
endif
for g:clangd_cmd in ['clangd', 'clangd-9']
    if executable(g:clangd_cmd)
        " sudo apt install clangd or clangd-9 (ubuntu bionic)
        au User lsp_setup call lsp#register_server({
           \ 'name': g:clangd_cmd,
           \ 'cmd': {server_info->[g:clangd_cmd, '--background-index', '--header-insertion=never']},
           \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp'],
           \ })
        break
    endif
endfor
if executable('ocamllsp')
    au User lsp_setup call lsp#register_server({
       \ 'name': 'ocamllsp',
       \ 'cmd': {server_info->['ocamllsp']},
       \ 'allowlist': ['ocaml'],
       \ })
endif

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
    \ 'name': 'omni',
    \ 'allowlist': ['tex'],
    \ 'blocklist': ['c', 'cpp', 'ocaml', 'python'],
    \ 'completor': function('asyncomplete#sources#omni#completor'),
    \ 'config': {
    \   'show_source_kind': 1
    \ }
    \ }))
"}}}

"" vsnip {{{
" avoid loading vsnip on old vim
if !exists("##TextChangedP")
    let g:loaded_vsnip = 1
endif
" modified version of expand_or_jump() (added set nofoldenable before expand()).
" see vim-vsnip/plugin/vsnip.vim for the original.
inoremap <silent> <Plug>(my-vsnip-expand-or-jump) <Esc>:<C-u>call <SID>expand_or_jump()<CR>
snoremap <silent> <Plug>(my-vsnip-expand-or-jump) <Esc>:<C-u>call <SID>expand_or_jump()<CR>
function! s:expand_or_jump()
    let l:context = vsnip#get_context()
    let l:session = vsnip#get_session()
    if !empty(l:context)
        set nofoldenable
        call vsnip#expand()
    elseif !empty(l:session) && l:session.jumpable(1)
        call l:session.jump(1)
    endif
endfunction

let g:vsnip_snippet_dir = expand('~/dotfiles/vsnip')
imap <expr> <C-f>   vsnip#available(1)  ? '<Plug>(my-vsnip-expand-or-jump)' : '<C-f>'
smap <expr> <C-f>   vsnip#available(1)  ? '<Plug>(my-vsnip-expand-or-jump)' : '<C-f>'
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'         : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'         : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'         : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'         : '<S-Tab>'
" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)
"}}}
"
"" neoformat {{{
nnoremap <silent> <Leader>f :<C-u>Neoformat<CR>

let g:neoformat_ocaml_ocamlformat = {
    \ 'exe': 'ocamlformat',
    \ 'no_append': 1,
    \ 'stdin': 1,
    \ 'args': ['--enable-outside-detected-project', '--name', '"%:p"', '-']
    \ }

let g:neoformat_enabled_ocaml = ['ocamlformat']

let g:neoformat_python_black = {
    \ 'exe': 'black',
    \ 'stdin': 1,
    \ 'args': ['-q', '-'],
    \ }
let g:neoformat_python_yapf = {
    \ 'exe': 'yapf',
    \ 'stdin': 1,
    \ }
let g:neoformat_python_autopep8 = {
    \ 'exe': 'autopep8',
    \ 'stdin': 1,
    \ 'args': ['-'],
    \ }
let g:neoformat_enabled_python = ['black', 'yapf', 'autopep8']

if executable('clang-format')
    " sudo apt install clang-format
    let g:neoformat_c_clangformat = {
        \ 'exe': 'clang-format',
        \ 'args': ['--assume-filename=' . expand('%:t')],
        \ 'stdin': 1,
        \ }
    let g:neoformat_cpp_clangformat = g:neoformat_c_clangformat
    let g:neoformat_enabled_c = ['clangformat']
    let g:neoformat_enabled_cpp = g:neoformat_enabled_c
endif
"}}}

"" fzf {{{
let g:fzf_layout = { 'down': '40%' }
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

"" slime {{{
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
let g:slime_python_ipython = 1
"}}}

"" Tagbar {{{
nnoremap <silent> <Leader>b :<C-u>TagbarToggle<CR>
let g:tagbar_map_togglesort = "r"
let g:tagbar_sort = 0
let g:tagbar_left = 1
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
let g:vimtex_toc_config = {
    \ 'name': 'ToC',
    \ 'mode': 2 }
let g:vimtex_quickfix_ignore_filters = [
    \ 'LaTeX Font Warning',
    \]
"}}}
"}}}

""" Colorscheme {{{
silent! colorscheme jellybeans
"}}}
