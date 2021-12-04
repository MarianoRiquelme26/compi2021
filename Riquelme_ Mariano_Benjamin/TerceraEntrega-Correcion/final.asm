INCLUDE macros2.asm
INCLUDE number.asm
.MODEL LARGE			;Modelo de Memoria
.386					;Tipo de Procesador
.STACK 200h				;Bytes en el Stack

.DATA

_1                            	dd		1		;Constante en formato CTE_INTEGER;
_2                            	dd		2		;Constante en formato CTE_INTEGER;
_algo                         	dd		-		;Constante en formato CTE_STRING;
_3                            	dd		3		;Constante en formato CTE_INTEGER;
_algo2                        	dd		-		;Constante en formato CTE_STRING;
_6                            	dd		6		;Constante en formato CTE_INTEGER;
_10                           	dd		10		;Constante en formato CTE_INTEGER;
_100                          	dd		100		;Constante en formato CTE_INTEGER;
a                             	dd		?		;Variable
b                             	dd		?		;Variable
z                             	dd		?		;Variable
@auxCE	 	 	 		dd		0.0		;Variable auxiliar para ciclo especial
@aux0                             	dd		0.0		;Variable auxiliar
@aux1                             	dd		0.0		;Variable auxiliar
@aux2                             	dd		0.0		;Variable auxiliar
@aux3                             	dd		0.0		;Variable auxiliar
@aux4                             	dd		0.0		;Variable auxiliar
@aux5                             	dd		0.0		;Variable auxiliar
@aux6                             	dd		0.0		;Variable auxiliar
@aux7                             	dd		0.0		;Variable auxiliar
@aux8                             	dd		0.0		;Variable auxiliar
@aux9                             	dd		0.0		;Variable auxiliar
@cte2                             	dd		2		;constante para uso de long
@cte5                             	dd		5		;constante para uso de long


.CODE
START:
mov AX,@DATA
mov DS,AX
mov es,ax;


 fld _1
 fstp a;ASIGNACION


 fld @cte2
 fstp z;ASIGNACION


 fld _2
 fstp b;ASIGNACION


 fld @cte5
 fstp a;ASIGNACION


DisplayString _algo,2


 ETIQUETA_24 :
 fld _2
 fld _3
 fadd	;SUMA
 fstp @aux0 ;ASIGNACION


 fld @aux0
 fstp @auxCE;ASIGNACION


 fld @auxCE
 fld a
 fxch
 fcom
 fstsw ax
 sahf
 JE ETIQUETA_43

 fld _2
 fld b
 fadd	;SUMA
 fstp @aux1 ;ASIGNACION


 fld @aux1
 fstp @auxCE;ASIGNACION


 fld @auxCE
 fld a
 fxch
 fcom
 fstsw ax
 sahf
 JNE ETIQUETA_50


 ETIQUETA_43 :
 fld a
 fld b
 fadd	;SUMA
 fstp @aux2 ;ASIGNACION


 fld @aux2
 fstp z;ASIGNACION


 jmp ETIQUETA_24


 ETIQUETA_50 :
DisplayString _algo2,2


 ETIQUETA_52 :
 fld a
 fld _2
 fxch
 fcom
 fstsw ax
 sahf
 JA ETIQUETA_78

 fld b
 fld _1
 fadd	;SUMA
 fstp @aux3 ;ASIGNACION


 fld @aux3
 fstp b;ASIGNACION



 ETIQUETA_63 :
 fld a
 fld _6
 fxch
 fcom
 fstsw ax
 sahf
 JB ETIQUETA_76

 fld a
 fld _2
 fadd	;SUMA
 fstp @aux4 ;ASIGNACION


 fld @aux4
 fstp a;ASIGNACION


 jmp ETIQUETA_63

 jmp ETIQUETA_52


 ETIQUETA_78 :
 fld a
 fld b
 fadd	;SUMA
 fstp @aux5 ;ASIGNACION


 fld @aux5
 fstp z;ASIGNACION


DisplayInteger z,2

DisplayInteger z,2

DisplayInteger z,2

DisplayInteger z,2

 fld z
 fld _1
 fxch
 fcom
 fstsw ax
 sahf
 JNA ETIQUETA_105

 fld a
 fld b
 fadd	;SUMA
 fstp @aux6 ;ASIGNACION


 fld @aux6
 fld _10
 fadd	;SUMA
 fstp @aux7 ;ASIGNACION


 fld @aux7
 fstp a;ASIGNACION


DisplayInteger a,2


 ETIQUETA_105 :
 fld a
 fld _1
 fxch
 fcom
 fstsw ax
 sahf
 JNA ETIQUETA_117

 fld _100
 fstp z;ASIGNACION


DisplayInteger z,2

 jmp ETIQUETA_134


 ETIQUETA_117 :
 fld z
 fld _10
 fxch
 fcom
 fstsw ax
 sahf
 JAE ETIQUETA_127

 fld _2
 fld _1
 fdiv	;DIVISION
 fstp @aux8;ASIGNACION


 fld @aux8
 fstp z;ASIGNACION



 ETIQUETA_127 :
 fld _2
 fld _2
 fdiv	;DIVISION
 fstp @aux9;ASIGNACION


 fld @aux9
 fstp z;ASIGNACION


DisplayString _1,2


 ETIQUETA_134 :
 fld a
 fld _1
 fxch
 fcom
 fstsw ax
 sahf
 JE ETIQUETA_147

 fld b
 fld _2
 fxch
 fcom
 fstsw ax
 sahf
 JE ETIQUETA_147

 fld _100
 fstp z;ASIGNACION



 ETIQUETA_147 :

mov ax,4c00h			;Indica que debe finalizar la ejecucion
int 21h

END START