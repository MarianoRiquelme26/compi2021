%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "funciones.c"

int yystopparser=0;
FILE *yyin;
int yyerror(char *mensaje);
int yylex();
char *yyltext;
int conadorDeclaracionesV = 0;
int conadorDeclaracionesT = 0;
int numeroPolaca = 0;
char idAux[30];


%}
%union 
{ 
    int intValue; 
    float floatValue; 
    char *stringValue; 
} 
%start programa
%token <stringValue> ID
%token OP_ASIG
%token CTE
%token COMEN
%token DISPLAY
%token CTE_S
%token ENTER
%token OP_SUM
%token OP_RES
%token OP_MUL
%token OP_DIV
%token PARA
%token PARC
%token GET
%token WHILE
%token START
%token END
%token OR
%token AND
%token COMPARADOR
%token IF
%token THEN
%token ELSE
%token ENDIF
%token DIM
%token CORA
%token CORC
%token AS
%token TIPO
%token COMA
%token LONG
%token IN
%token DO
%token ENDWHILE
%token CTE_R
%token NOT
%%

programa : programa sentencia {printf("\n---------------------->programa - Start detectado");}
		 |  sentencia  {printf("\n---------------------->programa - sentencia - Start detectado");} ;
		
		
sentencia : asignacion {printf("\n---------------------->sentencia - asignacion");}
		  | salida {printf("\n---------------------->sentencia - salida");}
		  | entrada {printf("\n---------------------->sentencia - entrada");}
		  | iteracion {printf("\n---------------------->sentencia - iteracion");}
		  | seleccion {printf("\n---------------------->sentencia - seleccion");}
		  |	declaracion {printf("\n---------------------->sentencia - declaracion");}
		  | COMEN {printf("\n");}
		  | LONG PARA lista PARC {printf("\n---------------------->sentencia - tema especial - long");}
		  | ciclo_especial {printf("\n---------------------->sentencia - tema especial - cilco especial");}
		  | ENTER {printf("\n");};

asignacion : ID OP_ASIG expresion {	printf("\n---------------------->asignacion");
									insertar_en_polaca_operador(":=", numeroPolaca);
									numeroPolaca++;
									insertar_en_polaca_id($<stringValue>1, numeroPolaca);
									numeroPolaca++;
			
			};
		
salida :    DISPLAY factor {printf("\n---------------------->salida - display");}
		  | DISPLAY CTE_S {printf("\n---------------------->salida - display");
					printf("\n---------------------->factor cte STRING");
			
				
				
						strcpy(idAux,yylval.stringValue);	
						guardar_cte_string(idAux);
					
					
					
		 }
			
		  		  	  
		  
		  ;
		  
		
		  
		  
		  
entrada:    GET ID {printf("\n---------------------->entrada");};

expresion : expresion OP_SUM termino {	printf("\n---------------------->expresion - SUM");
										insertar_en_polaca_operador("+", numeroPolaca);
										numeroPolaca++;
		   }
		  | expresion OP_RES termino {	printf("\n---------------------->expresion - RES");
										insertar_en_polaca_operador("-", numeroPolaca);
										numeroPolaca++;
		   }
		  | termino {printf("\n---------------------->expresion - termino");};
		  
iteracion: WHILE condicion START programa END {printf("\n---------------------->iteracion - while");};

seleccion :   IF  condicion THEN programa ELSE programa ENDIF {printf("\n---------------------->seleccion - if");}
			| IF condicion THEN programa ENDIF {printf("\n---------------------->seleccion - if");}
			;

condicion :   PARA condicion AND comparacion PARC {printf("\n---------------------->condicion");}
			| PARA condicion OR comparacion PARC {printf("\n---------------------->condicion");}
			| PARA NOT condicion PARC	{printf("\n---------------------->condicion");}
			| comparacion 	{printf("\n---------------------->condicion");};
			
comparacion: expresion COMPARADOR expresion {printf("\n---------------------->3 - condicion");}
			|PARA expresion COMPARADOR expresion PARC{printf("\n---------------------->3 - condicion");}
			;


termino   : termino OP_MUL factor {printf("\n---------------------->termino");
									insertar_en_polaca_operador("*", numeroPolaca);
									numeroPolaca++;
		  }
		  | termino OP_DIV factor {printf("\n---------------------->termino");
									insertar_en_polaca_operador("/", numeroPolaca);
									numeroPolaca++;
		  
		  }
		  | factor {printf("\n---------------------->termino - factor");};

factor :    ID {printf("\n---------------------->factor - id");
				insertar_en_polaca_id($<stringValue>1, numeroPolaca);
				numeroPolaca++;

		}
		
		  | CTE {
				printf("\n---------------------->factor - cte");
				char* nombre_cte_int = guardar_cte_int(atoi($<stringValue>1));
				insertar_en_polaca_cte_int(atoi($<stringValue>1), numeroPolaca);
				numeroPolaca++;
		}
		 |CTE_R {
					printf("\n---------------------->factor cte real");
					float valor = atof($<stringValue>1);
					char* nombre_cte_float = guardar_cte_float(valor);
					insertar_en_polaca_cte_real(atof($<stringValue>1), numeroPolaca);
					numeroPolaca++;
		 }
		 	 
		 
		 | PARA expresion PARC {printf("\n---------------------->factor - expresion");};
		 
declaracion : DIM CORA listav CORC AS CORA listat CORC 
			{ 
				guardar_variables_ts();
				freeArray(&array_nombres_variables);
				freeArray(&array_tipos_variables);
				
				initArray(&array_nombres_variables);
				initArray(&array_tipos_variables);
				
				int controlDeclaracion = conadorDeclaracionesV - conadorDeclaracionesT;
				conadorDeclaracionesV = 0;
				conadorDeclaracionesT = 0;
				if(controlDeclaracion != 0){
					yyerror("NO COINCIDEN LA CANTIDAD DE PARAMETROS CON LA CANTIDAD DE TIPOS");
					exit(1);
				}
					
				
			};

listav : listav COMA ID 
		{
			printf("\n---------------------->lista de variables");
			insertArray(&array_nombres_variables,$<stringValue>3);
			conadorDeclaracionesV += 1;
		}
		| ID 
		{	
			printf("\n---------------------->lista de variables - id");
			insertArray(&array_nombres_variables,$<stringValue>1);
			conadorDeclaracionesV += 1;
		}
		;
listat : listat COMA TIPO 
		{
			printf("\n---------------------->lista tipos");
			printf("********* tipo %s *********",$<stringValue>3);
			insertArray(&array_tipos_variables,$<stringValue>3);
			conadorDeclaracionesT += 1;
		}
		| TIPO 
		{
			printf("\n---------------------->lista TIPOS - corte");
			printf("********* tipo %s *********",$<stringValue>1);
			insertArray(&array_tipos_variables,$<stringValue>1);
			conadorDeclaracionesT += 1;
		};
		
lista : lista COMA factor {printf("\n---------------------->lista");}
		| factor {printf("\n---------------------->lista - factor");};
		
ciclo_especial : WHILE ID IN CORA lista_expre CORC DO programa ENDWHILE {printf("\n---------------------->ciclo especial");};

lista_expre : lista_expre COMA expresion {printf("\n---------------------->lista de expresiones");}
			| expresion {printf("\n---------------------->expresion - corte");}
			;

%%

int main (int argc,char *argv[]){

 if ((yyin=fopen(argv[1],"rt"))==NULL)
 {
  	printf("\nNo se puede abrir el archivo: %s\n",argv[1]);
 }
 else{
	initArray(&array_tipos_variables);
	initArray(&array_nombres_variables);
    crearTabla();
	crearPolaca();
	yyparse();
	guardar_ts();
	guardar_gci(numeroPolaca);
    freeArray(&array_tipos_variables);
	freeArray(&array_nombres_variables);
 }
 fclose(yyin);

 return 0;
}

int yyerror(char *mensaje)
	{ 
 	  printf("\nSyntax Error: %s\n", mensaje);
	  system("Pause");
          exit (1);
	}