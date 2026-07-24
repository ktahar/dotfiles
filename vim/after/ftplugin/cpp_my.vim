if exists('b:did_ftplugin_cpp_my')
    finish
endif
let b:did_ftplugin_cpp_my = 1

setl foldmethod=syntax

" LSP mappings
nnoremap <silent><buffer> <LocalLeader>t <Cmd>LspHover<CR>
nnoremap <silent><buffer> <LocalLeader>d <Cmd>LspGotoDefinition<CR>
nnoremap <silent><buffer> <LocalLeader>n <Cmd>LspDiag show<CR>
nnoremap <silent><buffer> <LocalLeader>N <Cmd>LspDiag current<CR>
nnoremap <silent><buffer> <LocalLeader>r <Cmd>LspRename<CR>
