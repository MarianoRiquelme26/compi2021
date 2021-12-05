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
_algo                         	db		"algo" ,'$',46 dup(?)		;Constante en formato CTE_STRING;
_str                          	db		"str" ,'$',47 dup(?)		;Constante en formato CTE_STRING;
_1_10                         	dd		1.10		;Constante en formato CTE_FLOAT;
_1                            	dd		1		;Constante en formato CTE_INTEGER;
_2                            	dd		2		;Constante en formato CTE_INTEGER;
_prueba_1                     	db		"prueba 1" ,'$',42 dup(?)		;Constante en formato CTE_STRING;
_3                            	dd		3		;Constante en formato CTE_INTEGER;
_9                            	dd		9		;Constante en formato CTE_INTEGER;
_prueba_2                     	db		"prueba 2" ,'$',42 dup(?)		;Constante en formato CTE_STRING;
_20                           	dd		20		;Constante en formato CTE_INTEGER;
_10                           	dd		10		;Constante en formato CTE_INTEGER;
_100                          	dd		100		;Constante en formato CTE_INTEGER;
_algo2                        	db		"algo2" ,'$',45 dup(?)		;Constante en formato CTE_STRING;
a                             	dd		?		;Variable de tipo integer
b                             	dd		?		;Variable de tipo integer
z                             	dd		?		;Variable de tipo integer
m                             	dd		?		;Variable de tipo real
z1                            	dd		?		;Variable de tipo string
z3                            	dd		?		;Variable de tipo string
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


 lea si, _algo
 lea di, z1
 STRCPY;ASIGNACION


 newLine 1
 DisplayString _str,2

 newLine 1
 DisplayString z1,2

 newLine 1
 DisplayString @msj,2

 GetString @auxstr
lea si, @auxstr
lea di, z3
STRCPY

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


 ETIQUETA_36 :
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
 JE ETIQUETA_55

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
 JNE ETIQUETA_65


 ETIQUETA_55 :
 fld a
 fld b
 fadd	;SUMA
 fstp @aux2 ;ASIGNACION


 fld @aux2
 fstp z;ASIGNACION


 fld _9
 fstp a;ASIGNACION


 jmp ETIQUETA_36


 ETIQUETA_65 :
 newLine 1
 DisplayString _prueba_2,2


 ETIQUETA_67 :
 fld a
 fld _2
 fxch
 fcom
 fstsw ax
 sahf
 JA ETIQUETA_93

 fld b
 fld _1
 fadd	;SUMA
 fstp @aux3 ;ASIGNACION


 fld @aux3
 fstp b;ASIGNACION



 ETIQUETA_78 :
 fld a
 fld _20
 fxch
 fcom
 fstsw ax
 sahf
 JB ETIQUETA_91

 fld a
 fld _2
 fadd	;SUMA
 fstp @aux4 ;ASIGNACION


 fld @aux4
 fstp a;ASIGNACION


 jmp ETIQUETA_78


 ETIQUETA_91 :
 jmp ETIQUETA_67


 ETIQUETA_93 :
 fld a
 fld b
 fadd	;SUMA
 fstp @aux5 ;ASIGNACION


 fld @aux5
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
 JNA ETIQUETA_120

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


 newLine 1
 DisplayInteger a,2


 ETIQUETA_120 :
 fld a
 fld _1
 fxch
 fcom
 fstsw ax
 sahf
 JNA ETIQUETA_132

 fld _100
 fstp z;ASIGNACION


 newLine 1
 DisplayInteger z,2

 jmp ETIQUETA_149


 ETIQUETA_132 :
 fld z
 fld _10
 fxch
 fcom
 fstsw ax
 sahf
 JAE ETIQUETA_142

 fld _2
 fld _1
 fdiv	;DIVISION
 fstp @aux8;ASIGNACION


 fld @aux8
 fstp z;ASIGNACION



 ETIQUETA_142 :
 fld _2
 fld _2
 fdiv	;DIVISION
 fstp @aux9;ASIGNACION


 fld @aux9
 fstp z;ASIGNACION


 newLine 1
 DisplayString _1,2


 ETIQUETA_149 :
 fld a
 fld _1
 fxch
 fcom
 fstsw ax
 sahf
 JE ETIQUETA_162

 fld b
 fld _2
 fxch
 fcom
 fstsw ax
 sahf
 JE ETIQUETA_162

 fld _100
 fstp z;ASIGNACION



 ETIQUETA_162 :
 lea si, _algo2
 lea di, z1
 STRCPY;ASIGNACION


 newLine 1
 DisplayString _algo2,2

 newLine 1
 DisplayString z1,2

 newLine 1
 DisplayString z3,2


mov ax,4c00h			;Indica que debe finalizar la ejecucion
int 21h

END START