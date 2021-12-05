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
edad                          	dd		?		;Variable de tipo integer
numero                        	dd		?		;Variable de tipo real
numwin                        	dd		?		;Variable de tipo real
pivote                        	dd		?		;Variable de tipo real
bandera                       	dd		?		;Variable de tipo integer
alterar                       	dd		?		;Variable de tipo integer
nombre                        	dd		?		;Variable de tipo string
_Ingrese_su_edad_             	db		"Ingrese su edad " ,'$',34 dup(?)		;Constante en formato CTE_STRING;
_18                           	dd		18		;Constante en formato CTE_INTEGER;
_Eres_menor_no_puedes_jugar   	db		"Eres menor no puedes jugar" ,'$',24 dup(?)		;Constante en formato CTE_STRING;
_Diga_su_edad_de_nuevo_       	db		"Diga su edad de nuevo " ,'$',28 dup(?)		;Constante en formato CTE_STRING;
_Bienvenido_al_juego          	db		"Bienvenido al juego" ,'$',31 dup(?)		;Constante en formato CTE_STRING;
_Diga_un_numero_real_         	db		"Diga un numero real " ,'$',30 dup(?)		;Constante en formato CTE_STRING;
_6_25                         	dd		6.25		;Constante en formato CTE_FLOAT;
_3_14                         	dd		3.14		;Constante en formato CTE_FLOAT;
_0                            	dd		0		;Constante en formato CTE_INTEGER;
_14_50                        	dd		14.50		;Constante en formato CTE_FLOAT;
_25_50                        	dd		25.50		;Constante en formato CTE_FLOAT;
_6_75                         	dd		6.75		;Constante en formato CTE_FLOAT;
_1                            	dd		1		;Constante en formato CTE_INTEGER;
_Ganaste                      	db		"Ganaste" ,'$',43 dup(?)		;Constante en formato CTE_STRING;
_65                           	dd		65		;Constante en formato CTE_INTEGER;
_499_50                       	dd		499.50		;Constante en formato CTE_FLOAT;
_40                           	dd		40		;Constante en formato CTE_INTEGER;
_29_99                        	dd		29.99		;Constante en formato CTE_FLOAT;
_Perdiste_no_pudo_ser         	db		"Perdiste no pudo ser" ,'$',30 dup(?)		;Constante en formato CTE_STRING;
@auxCE	 	 	 		dd		0.0		;Variable auxiliar para ciclo especial
@aux0                             	dd		0.0		;Variable auxiliar
@aux1                             	dd		0.0		;Variable auxiliar
@aux2                             	dd		0.0		;Variable auxiliar
@aux3                             	dd		0.0		;Variable auxiliar
@aux4                             	dd		0.0		;Variable auxiliar
@cte4                             	dd		4		;constante para uso de long


.CODE
START:
mov AX,@DATA
mov DS,AX
mov es,ax;


 newLine 1
 DisplayString _Ingrese_su_edad_,2

 newLine 1
 DisplayString @msj,2

 GetInteger edad


 ETIQUETA_14 :
 fld edad
 fld _18
 fxch
 fcom
 fstsw ax
 sahf
 JAE ETIQUETA_28

 newLine 1
 DisplayString _Eres_menor_no_puedes_jugar,2

 newLine 1
 DisplayString _Diga_su_edad_de_nuevo_,2

 newLine 1
 DisplayString @msj,2

 GetInteger edad

 jmp ETIQUETA_14


 ETIQUETA_28 :
 newLine 1
 DisplayString _Bienvenido_al_juego,2

 newLine 1
 DisplayString _Diga_un_numero_real_,2

 newLine 1
 DisplayString @msj,2

 GetFloat numero

 fld numero
 fld _6_25
 fdiv	;DIVISION
 fstp @aux0;ASIGNACION


 fld @aux0
 fstp numwin;ASIGNACION


 fld _3_14
 fstp pivote;ASIGNACION


 fld _0
 fstp bandera;ASIGNACION


 fld @cte4
 fstp alterar;ASIGNACION


 fld edad
 fld alterar
 fsub	;RESTA
 fstp @aux1;ASIGNACION


 fld @aux1
 fstp edad;ASIGNACION



 ETIQUETA_53 :
 fld _14_50
 fld _25_50
 fadd	;SUMA
 fstp @aux2 ;ASIGNACION


 fld @aux2
 fstp @auxCE;ASIGNACION


 fld @auxCE
 fld numwin
 fxch
 fcom
 fstsw ax
 sahf
 JE ETIQUETA_79

 fld _6_75
 fld pivote 
 fmul	;MULTIPLICACION
 fstp @aux3;ASIGNACION


 fld @aux3
 fstp @auxCE;ASIGNACION


 fld @auxCE
 fld numwin
 fxch
 fcom
 fstsw ax
 sahf
 JE ETIQUETA_79

 fld _1
 fstp @auxCE;ASIGNACION


 fld @auxCE
 fld numwin
 fxch
 fcom
 fstsw ax
 sahf
 JNE ETIQUETA_91


 ETIQUETA_79 :
 fld pivote
 fld pivote 
 fmul	;MULTIPLICACION
 fstp @aux4;ASIGNACION


 fld @aux4
 fstp numwin;ASIGNACION


 newLine 1
 DisplayString _Ganaste,2

 fld _1
 fstp bandera;ASIGNACION


 jmp ETIQUETA_53


 ETIQUETA_91 :
 fld edad
 fld _65
 fxch
 fcom
 fstsw ax
 sahf
 JE ETIQUETA_101

 fld numwin
 fld _499_50
 fxch
 fcom
 fstsw ax
 sahf
 JNA ETIQUETA_106


 ETIQUETA_101 :
 newLine 1
 DisplayString _Ganaste,2

 fld _1
 fstp bandera;ASIGNACION



 ETIQUETA_106 :
 fld edad
 fld _40
 fxch
 fcom
 fstsw ax
 sahf
 JAE ETIQUETA_123

 fld numwin
 fld _29_99
 fxch
 fcom
 fstsw ax
 sahf
 JNA ETIQUETA_123

 newLine 1
 DisplayString _Ganaste,2

 fld _1
 fstp bandera;ASIGNACION


 jmp ETIQUETA_130


 ETIQUETA_123 :
 fld bandera
 fld _0
 fxch
 fcom
 fstsw ax
 sahf
 JNE ETIQUETA_130

 newLine 1
 DisplayString _Perdiste_no_pudo_ser,2


 ETIQUETA_130 :

mov ax,4c00h			;Indica que debe finalizar la ejecucion
int 21h

END START