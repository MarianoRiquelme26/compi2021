%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *yyin;
int yylval;
char *yyltext;
%}

%option noyywrap
%option yylineno



WHILE		"WHILE"
ENDWHILE	"ENDWHILE"
DO			"DO"
IF			"IF"
ENDIF		"ENDIF"
INTEGER     "integer"
REAL 		"real"
STRING 		"string"
AS			"AS"
DISPLAY		"DISPLAY"
GET			"GET"
AND 		"AND"
OR          "OR"
NOT 		"NOT"
DIM			"DIM"
LONG		"long"
IN 			"IN"

COMILLA			["]
ASIG			":="
PAR_I			"("
PAR_F			")"
LLAVE_I			"{"
LLAVE_F			"}"
OP_SUM			"+"
OP_RES			"-"
OP_MUL			"*"
OP_DIV			"/"
COM_ABRE		"*/"
COM_CIER      	"/*"
PUNTO			"."
COMA			","
CAR_ESP			"@"|"%"|" "|":"
MAYOR  			">"
MENOR  			"<"
IGUAL		 	"=="
MAY_IGUAL 		">="
MEN_IGUAL 		"<="
DISTINTO  		"!="|"<>"	
COR_ABRE		"["
COR_CIER		"]"


DIGITO		[0-9]
CTE_R		{DIGITO}+.{PUNTO}.{DIGITO}*|{DIGITO}*.{PUNTO}.{DIGITO}+
CTE_E		{DIGITO}+
LETRA		[a-zA-Z]
CTE_S		{COMILLA}.({CAR_ESP}|{DIGITO}|{LETRA})*.{COMILLA}
COMEN		{COM_ABRE}.({CAR_ESP}|{DIGITO}|{LETRA})*.{COM_CIER}
VARIABLE	({DIGITO}|{LETRA})*


%%

{WHILE}		{printf("\nDetectado WHILE: %s",yytext);}
{ENDWHILE}	{printf("\nDetectado ENDWHILE: %s",yytext);}
{DO}		{printf("\nDetectado DO: %s",yytext);}
{IF}		{printf("\nDetectado IF: %s",yytext);}
{ENDIF}		{printf("\nDetectado ENDIF: %s",yytext);}
{INTEGER}   {printf("\nDetectado INTEGER: %s",yytext);}
{REAL} 		{printf("\nDetectado REAL: %s",yytext);}
{STRING} 	{printf("\nDetectado STRING: %s",yytext);}
{AS}		{printf("\nDetectado AS: %s",yytext);}
{DISPLAY}	{printf("\nDetectado DISPLAY: %s",yytext);}
{GET}		{printf("\nDetectado GET: %s",yytext);}
{AND} 		{printf("\nDetectado AND: %s",yytext);}
{OR}        {printf("\nDetectado OR: %s",yytext);}
{NOT} 		{printf("\nDetectado NOT: %s",yytext);}
{DIM}		{printf("\nDetectado DIM: %s",yytext);}
{LONG}		{printf("\nDetectado LONG: %s",yytext);}
{IN}		{printf("\nDetectado IN: %s",yytext);}
{ASIG}		{printf("\nDetectado ASIG: %s",yytext);}
{PAR_I}		{printf("\nDetectado PAR_I: %s",yytext);}
{PAR_F}		{printf("\nDetectado PAR_F: %s",yytext);}
{LLAVE_I}	{printf("\nDetectado LLAVE_I: %s",yytext);}
{LLAVE_F}	{printf("\nDetectado LLAVE_F: %s",yytext);}
{OP_SUM}	{printf("\nDetectado OP_SUM: %s",yytext);}
{OP_RES}	{printf("\nDetectado OP_RES: %s",yytext);}
{OP_MUL}	{printf("\nDetectado OP_MUL: %s",yytext);}
{OP_DIV}	{printf("\nDetectado OP_DIV: %s",yytext);}
{COM_ABRE}	{printf("\nDetectado COM_ABRE: %s",yytext);}
{COM_CIER}  {printf("\nDetectado COM_CIER: %s",yytext);}
{PUNTO}		{printf("\nDetectado PUNTO: %s",yytext);}
{COMA}		{printf("\nDetectado COMA: %s",yytext);}
{CAR_ESP}	{printf("\nDetectado CAR_ESP: %s",yytext);}
{MAYOR}  	{printf("\nDetectado MAYOR: %s",yytext);}
{MENOR}  	{printf("\nDetectado MENOR: %s",yytext);}
{IGUAL}		{printf("\nDetectado IGUAL: %s",yytext);}
{MAY_IGUAL} {printf("\nDetectado MAY_IGUAL: %s",yytext);}
{MEN_IGUAL} {printf("\nDetectado MEN_IGUAL: %s",yytext);}
{DISTINTO}  {printf("\nDetectado DISTINTO: %s",yytext);}
{COMILLA}	{printf("\nDetectado COMILLA: %s",yytext);}
{COR_ABRE}	{printf("\nDetectado COR_ABRE: %s",yytext);}
{COR_CIER}	{printf("\nDetectado COR_CIER: %s",yytext);}
{CTE_R}		{printf("\nDetectado CTE_R: %s",yytext);}
{CTE_E}		{printf("\nDetectado CTE_E: %s",yytext);}
{LETRA}		{printf("\nDetectado LETRA: %s",yytext);}
{CTE_S}		{printf("\nDetectado CTE_S: %s",yytext);}
{COMEN}		{printf("\nDetectado COMEN: %s",yytext);}
{VARIABLE}	{printf("\nDetectado VARIABLE: %s",yytext);}

"\n"
"\t"

%%

int main (int argc,char *argv[]){
	
	
	if( (yyin = fopen(argv[1],"rt")) == NULL){
		printf("\nNo se pudeo abrir el archivo: %s\n",argv[1]);
		return 1;
	}
	else {
		printf("\nSe pudeo abrir el archivo: %s\n",argv[1]);
		yylex();
	}
	fclose(yyin);
	return 0;
}

int yyerror(void){ 
 	  printf("Syntax Error\n");
          exit(1);
}