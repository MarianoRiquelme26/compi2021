INCLUDE macros2.asm
INCLUDE number.asm
.MODEL LARGE			;Modelo de Memoria
.386					;Tipo de Procesador
.STACK 200h				;Bytes en el Stack

MAXTEXTSIZE equ 50
.DATA

_SABADO_A_LA_TARDE_Y_ME_QUIER 	db		"SABADO A LA TARDE Y ME QUIER" ,'$',22 dup(?)		;Constante en formato CTE_STRING;
a                             	dd		?		;Variable de tipo real
b                             	dd		?		;Variable de tipo integer
z                             	dd		?		;Variable de tipo integer
m                             	dd		?		;Variable de tipo real


.CODE
START:
mov AX,@DATA
mov DS,AX
mov es,ax;


 newLine 1
 DisplayString _SABADO_A_LA_TARDE_Y_ME_QUIER,2


mov ax,4c00h			;Indica que debe finalizar la ejecucion
int 21h

END START