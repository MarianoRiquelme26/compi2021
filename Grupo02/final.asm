.MODEL LARGE			;Modelo de Memoria
.386					;Tipo de Procesador
.STACK 200h				;Bytes en el Stack

.DATA

cont                          	dd		?		;Variable
promedio                      	dd		?		;Variable
prueba                        	dd		?		;Variable
actual                        	dd		?		;Variable
a                             	dd		?		;Variable
suma                          	dd		?		;Variable
b                             	dd		?		;Variable
c                             	dd		?		;Variable
e                             	dd		?		;Variable
_Prue                         	dd		-		;Constante en formato CTE_STRING;
_65534                        	dd		65534		;Constante en formato CTE_INTEGER;
_9                            	dd		9		;Constante en formato CTE_INTEGER;
_1                            	dd		1		;Constante en formato CTE_INTEGER;
_2                            	dd		2		;Constante en formato CTE_INTEGER;
_suma                         	dd		-		;Constante en formato CTE_STRING;
_HOLA                         	dd		-		;Constante en formato CTE_STRING;
_0                            	dd		0		;Constante en formato CTE_INTEGER;
_mayor                        	dd		-		;Constante en formato CTE_STRING;
_10                           	dd		10		;Constante en formato CTE_INTEGER;
_mayor                        	dd		-		;Constante en formato CTE_STRING;
_menor                        	dd		-		;Constante en formato CTE_STRING;
_mayor                        	dd		-		;Constante en formato CTE_STRING;
_3                            	dd		3		;Constante en formato CTE_INTEGER;
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
_4                             	dd		4		;constante para uso de long


.CODE
mov AX,@DATA
mov DS,AX
mov es,ax;


 mov ah, 09h
 lea dx, _Prue
 int 21h
 mov ah, 3fh
 mov bx, 00
 mov cx, 100
 mov dx, offset[actual]
 mov 21h
 fild _65534
 fstp cont
 fild GET
 fstp cont

 ETIQUETA_19 :
 fld cont
 fld _9
 fxch
 fcom
 fstsw ax
 sahf
 JA ETIQUETA_63

 fild cont
 fild _1
 fadd	;SUMA
 fstp @aux0

 fild @aux0
 fstp cont
 fild ET
 fstp cont
 fild cont
 fild _2
 fdiv	;DIVISION
 fstp @aux1

 fild @aux1
 fstp actual
 fild DISPLAY
 fstp actual
 fild suma
 fild actual
 fadd	;SUMA
 fstp @aux2

 fild @aux2
 fstp suma
 fild @aux2
 fstp suma

 ETIQUETA_46 :
 fld e
 fld _9
 fxch
 fcom
 fstsw ax
 sahf
 JA ETIQUETA_61

 fild suma
 fild actual
 fadd	;SUMA
 fstp @aux3

 fild @aux3
 fstp suma
 fild ET
 fstp suma
 jmp ETIQUETA_46

 jmp ETIQUETA_19


 ETIQUETA_63 :
 mov ah, 09h
 lea dx, _suma
 int 21h
 mov ah, 09h
 lea dx, suma
 int 21h
 mov ah, 09h
 lea dx, _HOLA
 int 21h
 fld actual
 fld _1
 fxch
 fcom
 fstsw ax
 sahf
 JNA ETIQUETA_82

 fld actual
 fld _0
 fxch
 fcom
 fstsw ax
 sahf
 JE ETIQUETA_82

 mov ah, 09h
 lea dx, _mayor
 int 21h

 ETIQUETA_82 :
 fld actual
 fld _10
 fxch
 fcom
 fstsw ax
 sahf
 JB ETIQUETA_100

 mov ah, 09h
 lea dx, _mayor
 int 21h
 fld actual
 fld _10
 fxch
 fcom
 fstsw ax
 sahf
 JB ETIQUETA_98

 mov ah, 09h
 lea dx, _menor
 int 21h
 mov ah, 3fh
 mov bx, 00
 mov cx, 100
 mov dx, offset[actual]
 mov 21h
 jmp ETIQUETA_147


 ETIQUETA_100 :
 mov ah, 09h
 lea dx, _mayor
 int 21h
 fild _4
 fstp a

 ETIQUETA_105 :
 fild _1
 fild _3
 fadd	;SUMA
 fstp @aux4

 fild @aux4
 fstp @auxCE
 fld @auxCE
 fld a
 fxch
 fcom
 fstsw ax
 sahf
 JE ETIQUETA_124

 fild _2
 fild b
 fadd	;SUMA
 fstp @aux5

 fild @aux5
 fstp @aux
 fld ET
 fld a
 fxch
 fcom
 fstsw ax
 sahf
 JNE ETIQUETA_147


 ETIQUETA_124 :
 fild suma
 fild actual
 fadd	;SUMA
 fstp @aux6

 fild @aux6
 fstp suma
 fild DISPLAY
 fstp suma
 fild suma
 fild actual
 fadd	;SUMA
 fstp @aux7

 fild @aux7
 fstp suma
 fild 147
 fstp suma
 fild suma
 fild actual
 fadd	;SUMA
 fstp @aux8

 fild @aux8
 fstp suma
 fild GET
 fstp suma
 jmp ETIQUETA_105


mov ax,4c00h			;Indica que debe finalizar la ejecucion
int 21h

End