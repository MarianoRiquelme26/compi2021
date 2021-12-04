INCLUDE macros2.asm
INCLUDE number.asm
.MODEL LARGE			;Modelo de Memoria
.386					;Tipo de Procesador
.STACK 200h				;Bytes en el Stack

MAXTEXTSIZE equ 50
.DATA

_1_10                         	dd		1.10		;Constante en formato CTE_FLOAT;
_1                            	dd		1		;Constante en formato CTE_INTEGER;
_2                            	dd		2		;Constante en formato CTE_INTEGER;
_prueba_1                     	db		"prueba 1" ,'$',42 dup(?)		;Constante en formato CTE_STRING;
_prueba_2                     	db		"prueba 2" ,'$',42 dup(?)		;Constante en formato CTE_STRING;
_6                            	dd		6		;Constante en formato CTE_INTEGER;
_10                           	dd		10		;Constante en formato CTE_INTEGER;
_100                          	dd		100		;Constante en formato CTE_INTEGER;
a                             	dd		?		;Variable de tipo integer
b                             	dd		?		;Variable de tipo integer
z                             	dd		?		;Variable de tipo integer
m                             	dd		?		;Variable de tipo real
@aux0                             	dd		0.0		;Variable auxiliar
@aux1                             	dd		0.0		;Variable auxiliar
@aux2                             	dd		0.0		;Variable auxiliar
@aux3                             	dd		0.0		;Variable auxiliar
@aux4                             	dd		0.0		;Variable auxiliar
@aux5                             	dd		0.0		;Variable auxiliar
@aux6                             	dd		0.0		;Variable auxiliar
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
 fstp a;ASIGNACION


 fld @cte2
 fstp z;ASIGNACION


 fld _2
 fstp b;ASIGNACION


 fld @cte5
 fstp a;ASIGNACION


 newLine 1
 DisplayString _prueba_1,2

 newLine 1
 DisplayString _prueba_2,2


 ETIQUETA_29 :
 fld a
 fld _2
 fxch
 fcom
 fstsw ax
 sahf
 JA ETIQUETA_55

 fld b
 fld _1
 fadd	;SUMA
 fstp @aux0 ;ASIGNACION


 fld @aux0
 fstp b;ASIGNACION



 ETIQUETA_40 :
 fld a
 fld _6
 fxch
 fcom
 fstsw ax
 sahf
 JB ETIQUETA_53

 fld a
 fld _2
 fadd	;SUMA
 fstp @aux1 ;ASIGNACION


 fld @aux1
 fstp a;ASIGNACION


 jmp ETIQUETA_BI

 jmp ETIQUETA_BI


 ETIQUETA_53 :

 ETIQUETA_55 :
 fld a
 fld b
 fadd	;SUMA
 fstp @aux2 ;ASIGNACION


 fld @aux2
 fstp z;ASIGNACION


 newLine 1
 DisplayInteger z,2

 newLine 1
 DisplayInteger z,2

 newLine 1
 DisplayInteger z,2

 newLine 1
 DisplayInteger z,2

 fld z
 fld _1
 fxch
 fcom
 fstsw ax
 sahf
 JNA ETIQUETA_82

 fld a
 fld b
 fadd	;SUMA
 fstp @aux3 ;ASIGNACION


 fld @aux3
 fld _10
 fadd	;SUMA
 fstp @aux4 ;ASIGNACION


 fld @aux4
 fstp a;ASIGNACION


 newLine 1
 DisplayInteger a,2


 ETIQUETA_82 :
 fld a
 fld _1
 fxch
 fcom
 fstsw ax
 sahf
 JNA ETIQUETA_94

 fld _100
 fstp z;ASIGNACION


 newLine 1
 DisplayInteger z,2

 jmp ETIQUETA_BI


 ETIQUETA_94 :
 fld z
 fld _10
 fxch
 fcom
 fstsw ax
 sahf
 JAE ETIQUETA_104

 fld _2
 fld _1
 fdiv	;DIVISION
 fstp @aux5;ASIGNACION


 fld @aux5
 fstp z;ASIGNACION



 ETIQUETA_104 :
 fld _2
 fld _2
 fdiv	;DIVISION
 fstp @aux6;ASIGNACION


 fld @aux6
 fstp z;ASIGNACION


 newLine 1
 DisplayString _1,2

 fld a
 fld _1
 fxch
 fcom
 fstsw ax
 sahf
 JE ETIQUETA_124

 fld b
 fld _2
 fxch
 fcom
 fstsw ax
 sahf
 JE ETIQUETA_124

 fld _100
 fstp z;ASIGNACION



 ETIQUETA_124 :

mov ax,4c00h			;Indica que debe finalizar la ejecucion
int 21h

END START