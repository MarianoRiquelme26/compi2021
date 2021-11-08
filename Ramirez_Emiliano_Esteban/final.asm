.MODEL LARGE			;Modelo de Memoria
.386					;Tipo de Procesador
.STACK 200h				;Bytes en el Stack

.DATA

cont                          	dd		?		;Variable
promedio                      	dd		?		;Variable
prueba                        	dd		?		;Variable
suma                          	dd		?		;Variable
actual                        	dd		?		;Variable
a                             	dd		?		;Variable
b                             	dd		?		;Variable
c                             	dd		?		;Variable
e                             	dd		?		;Variable
Prue                          	dd		?		;Variable
_655                          	dd		655		;Constante en formato CTE_INTEGER;
_9                            	dd		9		;Constante en formato CTE_INTEGER;
_1                            	dd		1		;Constante en formato CTE_INTEGER;
_2                            	dd		2		;Constante en formato CTE_INTEGER;
suma                          	dd		?		;Variable
HOLA                          	dd		?		;Variable
_0                            	dd		0		;Constante en formato CTE_INTEGER;
mayor                         	dd		?		;Variable
_10                           	dd		10		;Constante en formato CTE_INTEGER;
mayor                         	dd		?		;Variable
menor                         	dd		?		;Variable
mayor                         	dd		?		;Variable


.CODE
mov AX,@DATA
mov DS,AX
mov es,ax;



mov ax,4c00h			;Indica que debe finalizar la ejecucion
int 21h

End