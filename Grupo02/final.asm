INCLUDE macros.asm
INCLUDE macros2.asm
INCLUDE number.asm
.MODEL LARGE			;Modelo de Memoria
.386					;Tipo de Procesador
.STACK 200h				;Bytes en el Stack

MAXTEXTSIZE equ 50
.DATA

@msj	db		"Ingrese valor de la variable: " ,'$',20 dup(?)		
@auxstr	dd		?
a                             	dd		?		;Variable de tipo integer
b                             	dd		?		;Variable de tipo integer
z                             	dd		?		;Variable de tipo integer
m                             	dd		?		;Variable de tipo real
z1                            	dd		?		;Variable de tipo string
z3                            	dd		?		;Variable de tipo string
_5_2                          	db		"5.2" ,'$',47 dup(?)		;Constante en formato CTE_STRING;


.CODE
START:
mov AX,@DATA
mov DS,AX
mov es,ax;


 lea si, _5_2
 lea di, z1
 STRCPY;ASIGNACION



mov ax,4c00h			;Indica que debe finalizar la ejecucion
int 21h

END START