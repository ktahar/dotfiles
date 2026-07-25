if exists('b:did_ftplugin_python_my')
    finish
endif
let b:did_ftplugin_python_my = 1

setl fileencoding=utf-8
setl foldmethod=indent

" LSP
nnoremap <silent><buffer> <LocalLeader>t <Cmd>LspHover<CR>
nnoremap <silent><buffer> <LocalLeader>d <Cmd>LspGotoDefinition<CR>
nnoremap <silent><buffer> <LocalLeader>n <Cmd>LspDiag show<CR>
nnoremap <silent><buffer> <LocalLeader>N <Cmd>LspDiag current<CR>
nnoremap <silent><buffer> <LocalLeader>i <Cmd>LspDiag highlight toggle<CR>
nnoremap <silent><buffer> <LocalLeader>r <Cmd>LspRename<CR>
nnoremap <silent><buffer> <LocalLeader>R <Cmd>LspShowReferences<CR>
nnoremap <silent><buffer> <LocalLeader>S <Cmd>LspDocumentSymbol<CR>

" Execute current file (python3 -> python)
function! s:ExecPy(interactive)
    lcd %:h
    let l:python = executable('python3') ? 'python3'
                \ : executable('python') ? 'python' : ''
    if !empty(l:python)
        execute '!' . l:python . (a:interactive ? ' -i' : '') . ' %'
    endif
endfunction
" non-interactive: <LocalLeader>e interactive <LocalLeader>E
nnoremap <silent><buffer> <LocalLeader>e :call <SID>ExecPy(v:false)<CR>
nnoremap <silent><buffer> <LocalLeader>E :call <SID>ExecPy(v:true)<CR>
