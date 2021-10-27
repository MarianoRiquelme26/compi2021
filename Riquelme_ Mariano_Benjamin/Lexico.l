%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include "y.tab.h"
FILE *yyin;
char *yyltext;



char auxS[100];


void quitarComillas();




%}
%option noyywrap
%option yylineno

DISPLAY	"DISPLAY"
GET "GET"
WHILE "WHILE"
WHILEE "WHILEE"
START "START"
END "END"
OR "OR"
AND "AND"
IF "IF"
THEN "THEN"
ELSE "ELSE"
ENDIF "ENDIF"
DIM "DIM"
LONG "long"
IN "IN"
DO "DO"
ENDWHILE "ENDWHILE"
NOT "NOT"
AS "AS"
TIPO "integer"|"real"|"string"

CORA "["
CORC "]"
COMA ","
COMILLA			["] 
OP_MAYORIGUAL   ">="    
OP_MENORIGUAL   "<="     
OP_IGUAL        "=="     
OP_MENOR        [<] 
OP_MAYOR   		[>]
OP_DISTINTO     "!="
PUNTO			"."
OP_ASIG  ":="
DIGITO	[0-9]
LETRA	[a-zA-Z]
ID	({DIGITO}|{LETRA})*
CTE	{DIGITO}+
CTE_R {DIGITO}+.{PUNTO}.{DIGITO}*|{DIGITO}*.{PUNTO}.{DIGITO}+
CAR_ESP			"@"|"%"|":"|" "|"~"|"¿"|"?"|"="|"@"|"!"|"¡"|"_"|"%"|" "|"."|"|"|","|"{"|"}"|"["|"]"|":"|"\""|"#"|"$"|"*"|"\/"|"\\"|"¬"|"+"|"-"|";"
CTE_S		{COMILLA}.({CAR_ESP}|{DIGITO}|{LETRA})*.{COMILLA}
COM_ABRE		"*/"
COM_CIER      	"/*"
COMEN		{COM_ABRE}.({CAR_ESP}*|{DIGITO}*|{LETRA}*)*.{COM_CIER}
ENTER 	"\n"
OP_SUM "+"
OP_RES "-"
OP_DIV [/]
PARA "("
PARC ")"
OP_MUL [*]



%%
{WHILE} {printf("\ntoken WHILE");return WHILE;}
{WHILEE} {printf("\ntoken WHILEE");return WHILEE;}
{OR} {printf("\ntoken OR");return OR;}
{AND} {printf("\ntoken AND");return AND;}
{START} {printf("\ntoken START");return START;}
{END} {printf("\ntoken END");return END;}
{IF} {printf("\ntoken IF");return IF;}
{THEN} {printf("\ntoken THEN");return THEN;}
{ELSE} {printf("\ntoken ELSE");return ELSE;}
{ENDIF} {printf("\ntoken ENDIF");return ENDIF;}
{DIM} {printf("\ntoken DIM");return DIM;}
{CORA} {printf("\ntoken CORA");return CORA;}
{CORC} {printf("\ntoken CORC");return CORC;}
{TIPO} {printf("\ntoken TIPO");yylval.stringValue = strdup(yytext); return TIPO;}
{AS} {printf("\ntoken AS");return AS;}
{LONG} {printf("\ntoken LONG");return LONG;}
{IN} {printf("\ntoken IN");return IN;}
{DO} {printf("\ntoken DO");return DO;}
{ENDWHILE} {printf("\ntoken ENDWHILE");return ENDWHILE;}
{NOT} {printf("\ntoken NOT");return NOT;}
{COMEN}		{return COMEN;}

{OP_MAYORIGUAL} {printf("\nToken OP_MAYORIGUAL");return OP_MAYORIGUAL;}     
{OP_MENORIGUAL} {printf("\nToken OP_MENORIGUAL");return OP_MENORIGUAL;}     
{OP_IGUAL}		{printf("\nToken OP_IGUAL");return OP_IGUAL;}
{OP_MENOR}    	{printf("\nToken OP_MENOR");return OP_MENOR;}
{OP_DISTINTO}	{printf("\nToken OP_DISTINTO");return OP_DISTINTO;}
{OP_MAYOR}		{printf("\nToken OP_MAYOR");return OP_MAYOR;}

{OP_ASIG} {printf("\ntoken OP_ASIG");return OP_ASIG;}
{GET} {printf("\ntoken GET: %s",yytext);return GET;}
{CTE} {
		printf("\ntoken CTE: %s",yytext);
		if(atoi(yytext) < 65535)
		{
			yylval.stringValue = strdup(yytext); 
			return CTE;
		}
		else
		{
			printf("\nError lexico - Se supero el limite de enteros (16 bits):  %s\n",yytext);
		}
		
	  }
{CTE_R} { 	
			printf("\ntoken CTE_R: %s",yytext);
			
			if(atof(yytext)>=-3.40282347e+38F && atof(yytext)<=3.40282347e+38F)
			{ 
				yylval.stringValue = strdup(yytext); 
				return CTE_R;
			}
			else 
			{
				printf("\nError lexico - Se supero el limite de reales (32 bits) %s:\n",yytext); 
			}
		}
{DISPLAY} {printf("\ntoken DISPLAY");return DISPLAY;}
{CTE_S} { 	
			printf("\ntoken CTE_S");
			if(strlen(yytext) < 31)
			{
			
				sprintf(auxS,"%s", yytext);
				quitarComillas();
				yylval.stringValue=auxS;    
				return CTE_S;
			}
			else
			{
				printf("\nError lexico - Se supero el limite DE caracteres para constantes alfanumericas %s:\n",yytext);
			}
										
			
                             
  

										
			
	    }
{ENTER} {return ENTER;}
{ID} {
		printf("\ntoken ID: %s",yytext);
		yylval.stringValue = strdup(yytext); 
		return ID;
	}
{OP_SUM} {printf("\ntoken OP_SUM: %s",yytext);return OP_SUM;}
{OP_RES} {printf("\ntoken OP_RES: %s",yytext);return OP_RES;}
{OP_DIV} {printf("\ntoken OP_DIV: %s",yytext);return OP_DIV;}
{PARA} {printf("\ntoken PARA: %s",yytext);return PARA;}
{PARC} {printf("\ntoken PARC: %s",yytext);return PARC;}
{COMA} {printf("\ntoken COMA: %s",yytext);return COMA;}
{OP_MUL} {printf("\ntoken OP_MUL: %s",yytext);return OP_MUL;}





"\t"
. 
%%





void quitarComillas() {
	int i = 0;
	while(auxS[i+1] != '\"') {
		auxS[i] = auxS[i+1];
		i++;
	}
	auxS[i] = '\0';
}

