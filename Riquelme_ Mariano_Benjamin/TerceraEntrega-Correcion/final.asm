INCLUDE macros2.asm
INCLUDE number.asm
.MODEL LARGE			;Modelo de Memoria
.386					;Tipo de Procesador
.STACK 200h				;Bytes en el Stack

MAXTEXTSIZE equ 50
.DATA

_algo                         	db		"algo" ,'$',46 dup(?)		;Constante en formato CTE_STRING;
_str:                         	db		"str:" ,'$',46 dup(?)		;Constante en formato CTE_STRING;
a                             	dd		?		;Variable de tipo integer
b                             	dd		?		;Variable de tipo integer
z                             	dd		?		;Variable de tipo string
m                             	dd		?		;Variable de tipo real


.CODE
START:
mov AX,@DATA
mov DS,AX
mov es,ax;


 fld _algo
 fstp z;ASIGNACION


 newLine 1
 DisplayString _str:,2

 newLine 1
 DisplayString z,2


mov ax,4c00h			;Indica que debe finalizar la ejecucion
int 21h

END START