c:\GnuWin32\bin\flex Lexico.l
c:\GnuWin32\bin\bison -dyv Sintactico.y
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o Grupo02.exe
Grupo02.exe prueba.txt
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h