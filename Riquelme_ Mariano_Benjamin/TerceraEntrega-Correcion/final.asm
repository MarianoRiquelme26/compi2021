INCLUDE macros2.asm
INCLUDE number.asm
.MODEL LARGE			;Modelo de Memoria
.386					;Tipo de Procesador
.STACK 200h				;Bytes en el Stack

MAXTEXTSIZE equ 50
.DATA

_1_10                         	dd		1.10		;Constante en formato CTE_FLOAT;
_1                            	dd		1		;Constante en formato CTE_INTEGER;
_1_20                         	dd		1.20		;Constante en formato CTE_FLOAT;
_2                            	dd		2		;Constante en formato CTE_INTEGER;
_prueba1                      	db		"prueba1" ,'$',43 dup(?)		;Constante en formato CTE_STRING;
a                             	dd		?		;Variable
b                             	dd		?		;Variable
z                             	dd		?		;Variable
m                             	dd		?		;Variable
@aux0                             	dd		0.0		;Variable auxiliar
@cte2                             	dd		2		;constante para uso de long
@cte5                             	dd		5		;constante para uso de long


.CODE
START:
mov AX,@DATA
mov DS,AX
mov es,ax;


 fld _1_10
 fstp m;ASIGNACION


 fld _1
 fld _1_20
 fadd	;SUMA
 fstp @aux0 ;ASIGNACION


 fld @aux0
 fstp a;ASIGNACION


 fld @cte2
 fstp z;ASIGNACION


 fld _2
 fstp b;ASIGNACION


 fld @cte5
 fstp a;ASIGNACION


newLine 1
DisplayString _prueba1,2

newLine 1
DisplayInteger m,2


mov ax,4c00h			;Indica que debe finalizar la ejecucion
int 21h

END START