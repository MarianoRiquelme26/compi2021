%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"
FILE  *yyin;
%}
%option noyywrap  
%option yylineno 



SIMBOL	("~"|"¿"|"?"|"="|"@"|"!"|"¡"|"_"|"%"|" "|"."|"|"|","|"{"|"}"|"["|"]"|":"|"\""|"#"|"$"|"*"|"\/"|"\\"|"¬"|"+"|"-"|";")+
DIGITO	[0-9]
LETRA	[a-zA-Z]
ID		{LETRA}({LETRA}|{DIGITO}|"_")*
PUNTO   "."

%%
":="			{ return OP_ASIG;}
":"             { return OP_DOSP;}
"+"				{ return OP_SUMA;}
"-"				{ return OP_RESTA;}
"*"				{ return OP_MUL;}
"/"				{ return OP_DIV;}
"%"				{ return RESTO;}
"("				{ return P_A;}
")"				{ return P_C;}
";"				{ return P_Y_C;}
"<="			{ return OP_MENIGU;}
">="			{ return OP_MAYIGU;}
"<"				{ return OP_CMPMEN;}
">"				{ return OP_CMPMAY;}
"=="			{ return OP_IGU;}
"&&"			{ return OP_AND;}
"\|\|"			{ return OP_OR;}
"!="			{ return OP_DIST;}
"!"				{ return OP_NOT;}
"{"				{ return OP_LLAV_A;}
"}"				{ return OP_LLAV_C;}
"["				{ return OP_CORCH_A;}
"]"				{ return OP_CORCH_C;}
","				{ return OP_COMA;}
"MAIN"          { return MAIN;}
"IF"            { return IF;}
"THEN"          { return THEN;}
"ENDIF"         { return ENDIF;}
"ELSE"			{ return ELSE;}
"IN"        	{ return IN;}
"ENDWHILE"		{ return ENDWHILE;}
"WHILE"		   	{ return WHILE;}
"AS"			{ return AS;}
"DIM"			{ return DIM;}
"FLOAT"        	{ return TIPO_FLOAT;}
"INT"			{ return TIPO_INT;}
"STRING"		{ return TIPO_STRING;}
"DISPLAY"		{ return DISPLAY;}
"GET"			{ return GET;}

{ID}			{ yylval.str_val = strdup(yytext); printf("\nIdentificador en lexico: %s\n", yylval.str_val); return ID;}

({DIGITO}*"."{DIGITO}+|{DIGITO}*"."{DIGITO}*) {yylval.val = atof(yytext); if(strlen(yytext) > 32) {printf("Linea: %d Real superior al permitido\n", yylineno); system("pause");exit(1);} else {return REAL;}}

{DIGITO}+	    { yylval.intval = atoi(yytext); if(strlen(yytext) > 16) {printf("\nLinea: %d Entero superior al permitido\n", yylineno); system("pause");exit(1);} else {return ENTERO;}}

"\""({LETRA}|{SIMBOL}|{DIGITO})+"\"" { yylval.str_val = yytext; printf("\nString en lexico: %s\n", yylval.str_val); if(strlen(yylval.str_val) > 32) {printf("Cadena superior a la permitida\n"); system("pause");exit(1);} else {return STRING;}}



"-/"({LETRA}|{DIGITO}|{SIMBOL}|"("|")"|"-/"({LETRA}|{DIGITO}|{SIMBOL}|"("|")")+"/-")+"/-"
" "
"\n"
"\t"
"\r"
"\t\n"

.			{ printf("\nCaracter %s no reconoido en la linea %d\n\n", strdup(yytext), yylineno); system("pause"); exit(1); }

%%

