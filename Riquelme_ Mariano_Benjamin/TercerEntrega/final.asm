.MODEL LARGE			;Modelo de Memoria
.386					;Tipo de Procesador
.STACK 200h				;Bytes en el Stack

.DATA

_3                            	dd		3		;Constante en formato CTE_INTEGER;
_8                            	dd		8		;Constante en formato CTE_INTEGER;
_1                            	dd		1		;Constante en formato CTE_INTEGER;
_5                            	dd		5		;Constante en formato CTE_INTEGER;
_6                            	dd		6		;Constante en formato CTE_INTEGER;
_7                            	dd		7		;Constante en formato CTE_INTEGER;
i                             	dd		?		;Variable
t                             	dd		?		;Variable
x                             	dd		?		;Variable
y                             	dd		?		;Variable
z                             	dd		?		;Variable
q                             	dd		?		;Variable
@auxCE	 	 	 		dd		?		;Variable auxiliar para ciclo especial
@aux0                             	dd		?		;Variable auxiliar
@aux1                             	dd		?		;Variable auxiliar
@aux2                             	dd		?		;Variable auxiliar
@aux3                             	dd		?		;Variable auxiliar
@aux4                             	dd		?		;Variable auxiliar
@aux5                             	dd		?		;Variable auxiliar
@aux6                             	dd		?		;Variable auxiliar
@aux7                             	dd		?		;Variable auxiliar
@aux8                             	dd		?		;Variable auxiliar
@aux9                             	dd		?		;Variable auxiliar
@aux10                            	dd		?		;Variable auxiliar


.CODE
mov AX,@DATA
mov DS,AX
mov es,ax;



 ETIQUETA_10 :
 fild z
 fild _3
 fadd	;SUMA
 fstp @aux0

 fild @aux0
 fstp @auxCE
 ;COMPARACION
 fld ET
 fld i
 fcomp
 fstsw ax
 sahf
 JE ETIQUETA_80

 fild t
 fild _8 
 fmul	;MULTIPLICACION
 fstp @aux1

 fild @aux1
 fstp @auxCE
 ;COMPARACION
 fld 80
 fld i
 fcomp
 fstsw ax
 sahf
 JE ETIQUETA_80

 fild x
 fild _1
 fadd	;SUMA
 fstp @aux2

 fild @aux2
 fstp @auxCE
 ;COMPARACION
 fld 80
 fld i
 fcomp
 fstsw ax
 sahf
 JE ETIQUETA_80

 fild y
 fild x
 fdiv	;DIVISION
 fstp @aux3

 fild @aux3
 fild _5 
 fmul	;MULTIPLICACION
 fstp @aux4

 fild @aux4
 fstp @auxCE
 ;COMPARACION
 fld 80
 fld i
 fcomp
 fstsw ax
 sahf
 JE ETIQUETA_80

 fild z
 fild _8
 fadd	;SUMA
 fstp @aux5

 fild @aux5
 fstp @auxCE
 ;COMPARACION
 fld 80
 fld i
 fcomp
 fstsw ax
 sahf
 JE ETIQUETA_80

 fild x
 fild _5
 fdiv	;DIVISION
 fstp @aux6

 fild @aux6
 fstp @auxCE
 ;COMPARACION
 fld 80
 fld i
 fcomp
 fstsw ax
 sahf
 JE ETIQUETA_80

 fild q
 fild _6
 fdiv	;DIVISION
 fstp @aux7

 fild @aux7
 fild _7 
 fmul	;MULTIPLICACION
 fstp @aux8

 fild @aux8
 fild _3
 fadd	;SUMA
 fstp @aux9

 fild @aux9
 fstp @aux
 ;COMPARACION
 fld 80
 fld i
 fcomp
 fstsw ax
 sahf
 JNE ETIQUETA_87


 ETIQUETA_80 :
 fild x
 fild _8
 fadd	;SUMA
 fstp @aux10

 fild @aux10
 fstp z ;SALTO INCONDICIONAL
 jmp ETIQUETA_10


mov ax,4c00h			;Indica que debe finalizar la ejecucion
int 21h

End