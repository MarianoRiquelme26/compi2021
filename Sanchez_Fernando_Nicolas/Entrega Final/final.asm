include number.asm
.MODEL SMALL           ;Modelo de Memoria
.386                    ;Tipo de Procesador
.STACK 200h             ;Bytes en el Stack

.DATA

z                               dd      ?       ;Variable
_8                              dd      8       ;Constante en formato CTE_INTEGER;
_3                              dd      3       ;Constante en formato CTE_INTEGER;
@aux0                               dd      ?      ;Variable auxiliar


.CODE
mov AX,@DATA
mov DS,AX
mov es,ax;

 fld _8
 fld _3
 fadd   ;SUMA
 fstp @aux0

 ffree
 fld @aux0
 fstp z

 DisplayInteger z,2
 
mov ax,4c00h            ;Indica que debe finalizar la ejecucion
int 21h

End