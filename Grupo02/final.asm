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
a                             	dd		?		;Variable de tipo integer
b                             	dd		?		;Variable de tipo integer
z                             	dd		?		;Variable de tipo integer
m                             	dd		?		;Variable de tipo real
z1                            	dd		?		;Variable de tipo string
z3                            	dd		?		;Variable de tipo string
_1                            	dd		1		;Constante en formato CTE_INTEGER;
_2                            	dd		2		;Constante en formato CTE_INTEGER;
_3                            	dd		3		;Constante en formato CTE_INTEGER;
_4_10                         	dd		4.10		;Constante en formato CTE_FLOAT;
_uno                          	db		"uno" ,'$',47 dup(?)		;Constante en formato CTE_STRING;
_1_20                         	dd		1.20		;Constante en formato CTE_FLOAT;
_Ganaste                      	db		"Ganaste" ,'$',43 dup(?)		;Constante en formato CTE_STRING;


.CODE
START:
mov AX,@DATA
mov DS,AX
mov es,ax;


 fld _1
 fstp a;ASIGNACION


 fld _2
 fstp b;ASIGNACION


 fld _3
 fstp z;ASIGNACION


 fld _4_10
 fstp m;ASIGNACION


 lea si, uno
 lea di, z1
 STRCPY;ASIGNACION


 fld a
 fld _1_20
 fxch
 fcom
 fstsw ax
 sahf
 JNA ETIQUETA_35

 newLine 1
 DisplayString _Ganaste,2

 fld _1
 fstp a;ASIGNACION



 ETIQUETA_35 :

mov ax,4c00h			;Indica que debe finalizar la ejecucion
int 21h

END START