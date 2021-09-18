bison -dyv Sintactico.y
flex Lexico.l
pause
gcc lex.yy.c y.tab.c -o Primera.exe
pause
Primera.exe prueba.txt
pause
del lex.yy.c
del Primera.exe