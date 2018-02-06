" Vim syntax for GridLAB-D model file
"

syn keyword glmInclude module
syn match glmInclude "#include"
syn keyword glmStatement clock object schedule
"syn keyword glmType name timezone starttime stoptime from to length configuration

hi def link glmInclude Include
hi def link glmStatement Statement
"hi def link glmType Type

syn region  glmString  start=+'+ end=+'+
syn region  glmString  start=+"+ end=+"+
hi def link glmString String

" Integers (taken from python)
syn match   glmNumber	"\<\%([1-9]\d*\|0\)[Ll]\=\>"
syn match   glmNumber	"\<\d\+[jJ]\>"
syn match   glmNumber	"\<\d\+[eE][+-]\=\d\+[jJ]\=\>"
syn match   glmNumber
    \ "\<\d\+\.\%([eE][+-]\=\d\+\)\=[jJ]\=\%(\W\|$\)\@="
syn match   glmNumber
    \ "\%(^\|\W\)\zs\d*\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>"

hi def link     glmNumber         Number

let b:current_syntax = 'glm'
