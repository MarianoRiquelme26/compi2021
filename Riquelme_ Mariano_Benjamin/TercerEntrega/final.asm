.MODEL LARGE			;Modelo de Memoria
.386					;Tipo de Procesador
.STACK 200h				;Bytes en el Stack

.DATA

along                         	dd		?		;Variable
b                             	dd		?		;Variable
c                             	dd		?		;Variable
e                             	dd		?		;Variable
_5                             	dd		5		;constante para uso de long


.CODE
mov AX,@DATA
mov DS,AX
mov es,ax;


 fild _5
 fstp along

mov ax,4c00h			;Indica que debe finalizar la ejecucion
int 21h

End