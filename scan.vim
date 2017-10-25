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

:let [s:VIM,s:XML] = [[],[]]
:function! s:ReportLast()
:	let s:VIM[-1]["string"] = join(s:VIM[-1].text,"")
:	let xml = []
:	let xml += [printf('<vim first="%d" last="%d" file="%s">', s:VIM[-1].first, s:VIM[-1].last, s:Entity(s:VIM[-1].file))]
:	let xml += [printf('<string>%s</string>', s:Entity(s:VIM[-1].string))]

:	let xml += ['<text>']
:	for v in s:VIM[-1].text | let xml += [printf('<char>%s</char>', s:Entity(v))] | endfor
:	let xml += ['</text>']

:	let xml += ['<syntax>']
:	for v in s:VIM[-1].syntax | let xml += [printf('<name>%s</name>', v)] | endfor
:	let xml += ['</syntax>']

:	let xml += ['</vim>']
:	let s:XML += [join(xml,'')]
":	call remote_send("LOG",printf("o%s\e",string(s:VIM[-1])))
:	call remote_send("LOG",printf("o%s\e",s:XML[-1]))
:endfunction

:function! s:AddChar(position, char, syntax, file)
:	if !empty(s:VIM) && s:VIM[-1].last+1 == a:position && s:VIM[-1].file == a:file && s:VIM[-1].syntax == a:syntax
:		let s:VIM[-1].last = a:position
:		let s:VIM[-1].text += [a:char]
:	else
:		if !empty(s:VIM) | call s:ReportLast() | endif
:		let s:VIM += [{'first': a:position, 'last': a:position, 'text':[a:char], 'syntax': a:syntax, 'file': a:file}]
:	endif
:endfunction

:function! s:Work()
:	let s:Syntax=map(synstack(line("."),col(".")),'synIDattr(v:val,"name")')
:	call execute("normal yl")
:	let [s:Position,s:Char,s:File] = [line2byte(line("."))+col(".")-1, @", expand("%:p")]
:	call s:AddChar(s:Position,s:Char,s:Syntax,s:File)
:endfunction

:if 0==len(getqflist()) | vimgrep /./g % | endif
:call remote_send("LOG", "o<xml>\e")
:silent cdo call s:Work()
:call s:ReportLast()
:call remote_send("LOG", "o</xml>\e")
:call remote_send("LOG", ":%!xmllint --format -\n")

