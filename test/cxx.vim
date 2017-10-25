:map \\ :echo map(synstack(line("."),col(".")),'synIDattr(v:val,"name")')<CR>
:map \1 :echo synstack(line("."),col("."))<CR>

:highlight clear
:highlight xComment             guifg=LightGray
":highlight xClass               guibg=Yellow
:highlight _xClassName_           guifg=Magenta
":highlight xClassBody           guibg=Brown
:highlight _xPropertyType_        guifg=Red
:highlight _xPropertyName_        guifg=Blue
:highlight _xFunctionReturn_      guifg=Cyan
:highlight _xFunctionName_        guifg=Orange
:highlight xFunctionArgs        guifg=Purple
:highlight _xFunctionArgType_     guifg=LightGreen
:highlight _xFunctionArgName_     guifg=Green
:highlight _xFunctionArgDefault_  guifg=DarkGreen


:syntax clear
:syntax sync fromstart
:syntax case match

:syntax match  xRoot /\%^\_.*\%$/ contains=xClass,xComment
:syntax region xComment start=+/\*+ end=+\*/+
:syntax match  xComment +//.*$+

:syntax match   xClass /struct\_s\+\h\i*\_s*{\_.\{-}}\_s*;/ contains=xClassKey
":syntax region  xClass start=/struct\_s\+\h\i*\_s*{/ end=/}\_s*;/ contained contains=xClassKey
:syntax keyword xClassKey struct nextgroup=_xClassName_ skipempty skipwhite

:syntax match  _xClassName_ /\h\i*/ contained nextgroup=xClassBody skipempty skipwhite
:syntax region xClassBody start=/{/ end=/}\_s*;/ contained contains=xClass,xProperty,xFunction,xComment

:syntax match  xProperty /\h\i*\(::\h\i*\)*\_s\+\h\i*\_s*;/ contained contains=_xPropertyType_
:syntax match  _xPropertyType_ /\h\i*\(::\h\i*\)*/ contained nextgroup=_xPropertyName_ skipwhite skipempty
:syntax match  _xPropertyName_ /\h\i*\ze\s*;/ contained

:syntax match  xFunction /\h\i*\s\+\h\i*\s*(\_[^()]*);/ contained contains=_xFunctionReturn_
:syntax match  _xFunctionReturn_ /\h\i*\%(::\h\i*\)*/ contained nextgroup=_xFunctionName_ skipwhite skipempty
:syntax match  _xFunctionName_ /\h\i*/ contained nextgroup=xFunctionArgs skipwhite skipempty
:syntax region xFunctionArgs matchgroup=_xFunctionArgsBegin_ start=/(/ matchgroup=_xFunctionArgsEnd_ end=/)\s*;/ matchgroup=NONE contained contains=_xFunctionArgType_,_xFunctionArgSeparator_
:syntax match  _xFunctionArgType_ /\h\i*\%(::\h\i*\)*/ contained nextgroup=_xFunctionArgName_ skipwhite skipempty
:syntax match  _xFunctionArgName_ /\h\i*/ contained nextgroup=_xFunctionArgDefault_ skipwhite skipempty
:syntax match  _xFunctionArgDefault_ /=\_s*\h\i\+/hs=s+1 contained
:syntax match  _xFunctionArgDefault_ /=\_s*\d\+/hs=s+1 contained
:syntax match  _xFunctionArgDefault_ /=\_s*0[xX]\x\+/hs=s+1 contained
:syntax match  _xFunctionArgDefault_ /=\_s*"[^"]*"/hs=s+1 contained
:syntax match  _xFunctionArgSeparator_ /,/ contained



