":let g:VimToolsScanOptions = {'output':"\(xml\|vim\)", 'parent':[]}
":let g:VimToolsScanOptions = {'output':'xml', 'parent':[]}
":let g:VimToolsScanOptions['parent'] = [
"\	['xClassName', 'xPropertyType', 'xPropertyName'],
"\	['xClassName', 'xFunctionReturn', 'xFunctionName', 'xFunctionArgType', 'xFunctionArgName', 'xFunctionArgDefault'],
"\]

:if 0 == count(serverlist(),"LOG")
:	!mvim --servername LOG
:	sleep
:endif
:call remote_send("LOG",'ggdG')

:function! s:Entity(str)
:	let tmp = a:str
:	let tmp = substitute(tmp, '&', '\&amp;', 'g')
:	let tmp = substitute(tmp, '<', '\&lt;', 'g')
:	return tmp
:endfunction

:let [s:VIM,s:XML,s:ID] = [[],{},0]
:function! s:ReportLast()
:	let s:VIM[-1]["text"] = join(s:VIM[-1].string,"")
:	let xml = []
:	let xml += [printf('<vim first="%d" last="%d" file="%s" id="%d" parent="%d">', s:VIM[-1].first, s:VIM[-1].last, s:Entity(s:VIM[-1].file), s:VIM[-1].id, s:VIM[-1].parent)]
:	let xml += [printf('<text>%s</text>', s:Entity(s:VIM[-1].text))]
:	let xml += ['<string>']
:	for v in s:VIM[-1].string | let xml += [printf('<char>%s</char>', s:Entity(v))] | endfor
:	let xml += ['</string>']
:	let xml += ['<syntax>']
:	for v in s:VIM[-1].syntax | let xml += [printf('<name>%s</name>', v)] | endfor
:	let xml += ['</syntax>']
:	let xml += ['</vim>']
:	if g:VimToolsScanOptions['output'] == 'vim'
:		call remote_send("LOG",printf("o%s\e",string(s:VIM[-1])))
:	elseif g:VimToolsScanOptions['output'] == 'xml'
:		call remote_send("LOG",printf("o%s\e",join(xml,'')))
:	endif
:endfunction

:function! s:FindParent_deprecated()
:	let i = -2
:	while {} !=# get(s:VIM, i, {})
:		let [C,P] = [s:VIM[-1].syntax, s:VIM[i].syntax]
:		if len(P) < len(C) && P == C[0:len(P)-1]
:			return s:VIM[i].id
:		endif
:		let i -= 1
:	endwhile
:	return -1
:endfunction

:function! s:FindParent()
:	let [C, parent] = [s:VIM[-1],'']
:	for rule in g:VimToolsScanOptions.parent
:		let i = index(rule, s:VIM[-1].syntax[-1])
:		if  0 == i | return -1 | endif
:		if -1 != i | let parent = rule[i-1] | break | endif
:	endfor
:	if '' == parent | return -1 | endif
:	let i = -2
:	while {} !=# get(s:VIM, i, {})
:		let P = s:VIM[i]
:		if P.file !=# C.file | break | endif
:		if P.syntax[-1] ==# parent | return P.id | endif
:		let i -= 1
:	endwhile
:	return -1
:endfunction

:function! s:AddChar(position, char, syntax, file)
:	if !empty(s:VIM) && s:VIM[-1].last+1 == a:position && s:VIM[-1].file == a:file && s:VIM[-1].syntax == a:syntax
:		let s:VIM[-1].last    = a:position
:		let s:VIM[-1].string += [a:char]
:	else
:		if !empty(s:VIM) | call s:ReportLast() | endif
:		let s:VIM += [{}]
:		let s:VIM[-1]['first']  = a:position
:		let s:VIM[-1]['last']   = a:position
:		let s:VIM[-1]['string'] = [a:char]
:		let s:VIM[-1]['syntax'] = a:syntax
:		let s:VIM[-1]['file']   = a:file
:		let s:VIM[-1]['id']     = s:ID
:		let s:VIM[-1]['parent'] = s:FindParent()
:		let s:ID += 1
:	endif
:endfunction

:function! s:Work()
:	let s:Syntax=map(synstack(line("."),col(".")),'synIDattr(v:val,"name")')
:	call execute("normal yl")
:	let [s:Position,s:Char,s:File] = [line2byte(line("."))+col(".")-1, @", expand("%:p")]
:	call s:AddChar(s:Position,s:Char,s:Syntax,s:File)
:endfunction

:if 0==len(getqflist()) | vimgrep /./g % | endif
:silent cdo call s:Work()
:call s:ReportLast()

:if g:VimToolsScanOptions['output'] == 'vim'
:elseif g:VimToolsScanOptions['output'] == 'xml'
:	call remote_send("LOG", "ggO<xml>\e")
:	call remote_send("LOG", "Go</xml>\e")
:	call remote_send("LOG", ":%!xmllint --format -\n")
:endif

