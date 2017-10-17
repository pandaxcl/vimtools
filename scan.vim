:set whichwrap+=l

:if 0 == count(serverlist(),"LOG")
:	!mvim --servername LOG
:	sleep
:	call remote_send("LOG",":vnew\<CR>")
:endif
:call remote_send("LOG",'ggdG')

:map \0 :let s:Syntax=map(synstack(line("."),col(".")),'synIDattr(v:val,"name")')<CR>
:map \1 yl:let [s:Position,s:Char] = [line2byte(line("."))+col(".")-1, strtrans(escape(@",'"\'))]<CR>
:map \2 :call remote_send("LOG",printf("o%8d, \"%s\", %s\e",s:Position,s:Char,s:Syntax))<CR>
:map \3 l
:let [@a,s:Repeat]=['\0\1\2\3', line2byte(line("$")+1)-1]
:map \a :normal gg<C-R>=s:Repeat<CR>@a<CR>
:normal \a

:set whichwrap&
