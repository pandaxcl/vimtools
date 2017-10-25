:if 0 == count(serverlist(),"LOG")
:	!mvim --servername LOG
:	sleep
:endif
:call remote_send("LOG",'ggdG')

:let HelloWorld = []
:function! s:AddChar(position, char, syntax)
:	if !empty(g:HelloWorld) && g:HelloWorld[-1].range.last+1 == a:position && g:HelloWorld[-1].syntax == a:syntax
:		let g:HelloWorld[-1].range.last = a:position
:		let g:HelloWorld[-1].text += [a:char]
:	else
:		if !empty(g:HelloWorld)
:			call remote_send("LOG",printf("o%s\e",string(g:HelloWorld[-1])))
:		endif
:		let g:HelloWorld += [{'range':{'first': a:position, 'last': a:position}, 'text':[a:char], 'syntax': a:syntax}]
:	endif
:endfunction

:function! s:Work()
:	let s:Syntax=map(synstack(line("."),col(".")),'synIDattr(v:val,"name")')
:	call execute("normal yl")
:	let [s:Position,s:Char] = [line2byte(line("."))+col(".")-1, strtrans(escape(@",'"\'))]
:	call s:AddChar(s:Position,s:Char,s:Syntax)
:endfunction

:vimgrep /./g %
:silent cdo call s:Work()
