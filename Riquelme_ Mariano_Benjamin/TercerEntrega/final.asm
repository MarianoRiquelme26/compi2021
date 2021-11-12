.MODEL LARGE			;Modelo de Memoria
.386					;Tipo de Procesador
.STACK 200h				;Bytes en el Stack

.DATA

_1                            	dd		1		;Constante en formato CTE_INTEGER;
_2                            	dd		2		;Constante en formato CTE_INTEGER;
_3                            	dd		3		;Constante en formato CTE_INTEGER;
a                             	dd		?		;Variable
b                             	dd		?		;Variable
c                             	dd		?		;Variable
d                             	dd		?		;Variable
e                             	dd		?		;Variable
f                             	dd		?		;Variable


.CODE
mov AX,@DATA
mov DS,AX
mov es,ax;


 ;COMPARACION
 fld a
 fld b
 fcomp
 fstsw ax
 sahf
 JNE ETIQUETA_20

 ;COMPARACION
 fld c
 fld d
 fcomp
 fstsw ax
 sahf
 JE ETIQUETA_25


 ETIQUETA_20 :
 fild _1
 fstp e ;SALTO INCONDICIONAL
 jmp ETIQUETA_28


 ETIQUETA_25 :
 fild _2
 fstp f

 ETIQUETA_28 :
 fild _3
 fstp f

mov ax,4c00h			;Indica que debe finalizar la ejecucion
int 21h

End