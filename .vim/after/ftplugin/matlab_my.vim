if exists('b:did_ftplugin_matlab_my')
    finish
endif
let b:did_ftplugin_matlab_my = 1

setl autoindent
setl smartindent cinwords=if,elseif,else,for,while,try,catch,function,classdef,properties,methods
