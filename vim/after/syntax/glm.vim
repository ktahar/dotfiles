" Vim syntax for GridLAB-D model file
"

"syn keyword glmInclude module
"syn keyword glmInclude link
syn match glmInclude "^\s*#\w*"
syn match glmInclude "^\s*link"
syn match glmInclude "^\s*module"
hi def link glmInclude Include

syn keyword glmStatement clock object schedule
hi def link glmStatement Statement

"syn keyword glmType name timezone starttime stoptime from to length configuration
"hi def link glmType Type

syn region  glmString  start=+'+ end=+'+
syn region  glmString  start=+"+ end=+"+
hi def link glmString String

syn region  glmComment start="//" end="$"
hi def link glmComment Comment

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
