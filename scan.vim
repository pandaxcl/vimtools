:if 0 == count(serverlist(),"LOG")
:	!mvim --servername LOG
:	sleep
:endif
:call remote_send("LOG",'ggdG')

:let [s:VIM,s:XML] = [[],[]]
:function! s:ReportLast()
:	let s:VIM[-1]["string"] = join(s:VIM[-1].text,"")
:	call remote_send("LOG",printf("o%s\e",string(s:VIM[-1])))
:endfunction

:function! s:AddChar(position, char, syntax)
:	if !empty(s:VIM) && s:VIM[-1].last+1 == a:position && s:VIM[-1].syntax == a:syntax
:		let s:VIM[-1].last = a:position
:		let s:VIM[-1].text += [a:char]
:	else
:		if !empty(s:VIM) | call s:ReportLast() | endif
:		let s:VIM += [{'first': a:position, 'last': a:position, 'text':[a:char], 'syntax': a:syntax}]
:	endif
:endfunction

:function! s:Work()
:	let s:Syntax=map(synstack(line("."),col(".")),'synIDattr(v:val,"name")')
:	call execute("normal yl")
:	let [s:Position,s:Char] = [line2byte(line("."))+col(".")-1, strtrans(escape(@",'"\'))]
:	call s:AddChar(s:Position,s:Char,s:Syntax)
:endfunction

:if 0==len(getqflist()) | vimgrep /./g % | endif
:silent cdo call s:Work()
:call s:ReportLast()

