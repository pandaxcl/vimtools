:map \\ :echo map(synstack(line("."),col(".")),'synIDattr(v:val,"name")')<CR>
:map \1 :echo synstack(line("."),col("."))<CR>

:highlight clear
:highlight xComment             guifg=LightGray
":highlight xClass               guibg=Yellow
:highlight xClassName           guifg=Magenta
":highlight xClassBody           guibg=Brown
:highlight xPropertyType        guifg=Red
:highlight xPropertyName        guifg=Blue
:highlight xFunctionReturn      guifg=Cyan
:highlight xFunctionName        guifg=Orange
:highlight xFunctionArgs        guifg=Purple
:highlight xFunctionArgType     guifg=LightGreen
:highlight xFunctionArgName     guifg=Green
:highlight xFunctionArgDefault  guifg=DarkGreen


:syntax clear
:syntax sync fromstart
:syntax case match

:syntax match  xRoot /\%^\_.*\%$/ contains=xClass,xComment
:syntax region xComment start=+/\*+ end=+\*/+
:syntax match  xComment +//.*$+

:syntax match   xClass /struct\_s\+\h\i*\_s*{\_.\{-}}\_s*;/ contains=xClassKey
":syntax region  xClass start=/struct\_s\+\h\i*\_s*{/ end=/}\_s*;/ contained contains=xClassKey
:syntax keyword xClassKey struct nextgroup=xClassName skipempty skipwhite

:syntax match  xClassName /\h\i*/ contained nextgroup=xClassBody skipempty skipwhite
:syntax region xClassBody start=/{/ end=/}\_s*;/ contained contains=xClass,xProperty,xFunction,xComment

:syntax match  xProperty /\h\i*\(::\h\i*\)*\_s\+\h\i*\_s*;/ contained contains=xPropertyType
:syntax match  xPropertyType /\h\i*\(::\h\i*\)*/ contained nextgroup=xPropertyName skipwhite skipempty
:syntax match  xPropertyName /\h\i*\ze\s*;/ contained

:syntax match  xFunction /\h\i*\s\+\h\i*\s*(\_[^()]*);/ contained contains=xFunctionReturn
:syntax match  xFunctionReturn /\h\i*\%(::\h\i*\)*/ contained nextgroup=xFunctionName skipwhite skipempty
:syntax match  xFunctionName /\h\i*/ contained nextgroup=xFunctionArgs skipwhite skipempty
:syntax region xFunctionArgs start=/(/ end=/)\s*;/ matchgroup=NONE contained contains=xFunctionArgType,xFunctionArgSeparator
:syntax match  xFunctionArgType /\h\i*\%(::\h\i*\)*/ contained nextgroup=xFunctionArgName skipwhite skipempty
:syntax match  xFunctionArgName /\h\i*/ contained nextgroup=xFunctionArgDefault skipwhite skipempty
:syntax match  xFunctionArgDefault /=\_s*\h\i\+/hs=s+1 contained
:syntax match  xFunctionArgDefault /=\_s*\d\+/hs=s+1 contained
:syntax match  xFunctionArgDefault /=\_s*0[xX]\x\+/hs=s+1 contained
:syntax match  xFunctionArgDefault /=\_s*"[^"]*"/hs=s+1 contained
:syntax match  xFunctionArgSeparator /,/ contained


:let g:VimToolsScanOption_Output = 'xml'
:let g:VimToolsScanOption_Relation = [
\	['xClassName', 'xPropertyType', 'xPropertyName'],
\	['xClassName', 'xFunctionReturn', 'xFunctionName', 'xFunctionArgType', 'xFunctionArgName'],
\	['xClassName', 'xFunctionReturn', 'xFunctionName', 'xFunctionArgType', 'xFunctionArgName', 'xFunctionArgDefault'],
\]
