.MODEL LARGE			;Modelo de Memoria
.386					;Tipo de Procesador
.STACK 200h				;Bytes en el Stack

.DATA

suma                          	dd		?		;Variable
_5                            	dd		5		;Constante en formato CTE_INTEGER;


.CODE
mov AX,@DATA
mov DS,AX
mov es,ax;



mov ax,4c00h			;Indica que debe finalizar la ejecucion
int 21h

End