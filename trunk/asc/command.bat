
rem compile to exe file 
rem java -jar asc.jar -exe avmplus_s.exe -import builtin.abc  -import shell_toplevel.abc abcdump.as

rem compile to abc
java -jar asc.jar -import playerglobal.abc -import builtin.abc  hello.as

rem decompile abc file
abcdump hello.abc

rem run abc file
avmplus Hello.abc

rem compile to swf
java -jar asc.jar -swf Hello,100,100 -import builtin.abc -import playerglobal.abc Hello.as