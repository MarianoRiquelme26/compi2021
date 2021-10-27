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
char operadorAux[30];
int _aux = -2;
int _auxComa = 0;
int _auxContador = 0;
char _auxID[30];
char _auxTemp[100];
int iterador;
int _contLong;

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
%token WHILEE
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
		  | ID OP_ASIG LONG{_contLong = 0;_aux = 0;}
		  PARA lista PARC { printf("\n---------------------->sentencia - tema especial - long");
							char str[30];
							itoa(_contLong+1,str,10);
							insertar_en_polaca_id(str, numeroPolaca);
							numeroPolaca++;
							insertar_en_polaca_id($<stringValue>1, numeroPolaca);
							numeroPolaca++;
							insertar_en_polaca_operador(":=", numeroPolaca);
							numeroPolaca++;
							_aux = -2;
							}
		  | ciclo_especial {printf("\n---------------------->sentencia - tema especial - cilco especial");}
		  | ENTER {printf("\n");};

asignacion : ID OP_ASIG expresion {	printf("\n---------------------->asignacion");									
									insertar_en_polaca_id($<stringValue>1, numeroPolaca);
									numeroPolaca++;
									insertar_en_polaca_operador(":=", numeroPolaca);
									numeroPolaca++;
			
			};
		
salida :    DISPLAY factor {printf("\n---------------------->salida - display");
					insertar_en_polaca_id($<stringValue>2, numeroPolaca);
					numeroPolaca++;
					insertar_en_polaca_operador("DISPLAY", numeroPolaca);
					numeroPolaca++;
					}
		  | DISPLAY CTE_S {printf("\n---------------------->salida - display");
					printf("\n---------------------->factor cte STRING");
					strcpy(idAux,yylval.stringValue);	
					guardar_cte_string(idAux);
					insertar_en_polaca_id($<stringValue>2, numeroPolaca);
					numeroPolaca++;
					insertar_en_polaca_operador("DISPLAY", numeroPolaca);
					numeroPolaca++;
					};
		  
entrada:    GET ID {printf("\n---------------------->entrada");
					insertar_en_polaca_id($<stringValue>2, numeroPolaca);
					numeroPolaca++;
					insertar_en_polaca_operador("GET", numeroPolaca);
					numeroPolaca++;};

expresion : expresion OP_SUM termino {	if(_aux == -2)
										{
										printf("\n---------------------->expresion - SUM");
										insertar_en_polaca_operador("+", numeroPolaca);
										numeroPolaca++;
										}
										else
										{//POR AHORA NO USO LA VARIABLE TEMPORAL
											//strcat(_auxTemp,'+'); 
										}

		   }
		  | expresion OP_RES termino {
										if( _aux == -2 )
										{			  
											printf("\n---------------------->expresion - RES");
											insertar_en_polaca_operador("-", numeroPolaca);
											numeroPolaca++;
										}
		   }
		  | termino {printf("\n---------------------->expresion - termino");};
		  
iteracion: WHILE {insertar_en_polaca_etiqueta_apilar(numeroPolaca); numeroPolaca++;}
		   condicion START programa {desapilar_e_insertar_en_celda(numeroPolaca+2);}
		   END {printf("\n---------------------->iteracion - while");
		        insertar_bi_desapilar(numeroPolaca);numeroPolaca += 2;
				};

seleccion :   IF condicion THEN programa 					    	
					{desapilar_e_insertar_en_celda(numeroPolaca+2);
					 insertar_en_polaca_salto_condicion(numeroPolaca);
					 numeroPolaca += 2;}
			  ELSE programa ENDIF {printf("\n---------------------->seleccion - if");
								   desapilar_e_insertar_en_celda(numeroPolaca);}
			| IF condicion THEN programa ENDIF {printf("\n---------------------->seleccion - if");
												desapilar_e_insertar_en_celda(numeroPolaca);}
			;

condicion :   PARA condicion AND comparacion PARC {printf("\n---------------------->condicion");}
			| PARA condicion OR comparacion PARC {printf("\n---------------------->condicion");}
			| PARA NOT condicion PARC	{printf("\n---------------------->condicion");}
			| comparacion 	{	printf("\n---------------------->condicion");								
			};
			
comparacion: expresion COMPARADOR expresion {printf("\n---------------------->3 - condicion");
											 insertar_en_polaca_operador("CMP", numeroPolaca); 
											 numeroPolaca++;
											 insertar_en_polaca_salto_condicion(numeroPolaca);
											 numeroPolaca += 2;
											 }
			|PARA expresion COMPARADOR expresion PARC{printf("\n---------------------->3 - condicion");
													  insertar_en_polaca_operador("CMP", numeroPolaca);
													  numeroPolaca++;
													  insertar_en_polaca_salto_condicion(numeroPolaca);
													  numeroPolaca += 2;
													  }

termino   : termino OP_MUL factor {
									if( _aux == -2 )
									{
										printf("\n---------------------->termino");
										insertar_en_polaca_operador("*", numeroPolaca);
										numeroPolaca++;	
									}
		  }
		  | termino OP_DIV factor {
									if( _aux == -2 )
									{
										printf("\n---------------------->termino");
										insertar_en_polaca_operador("/", numeroPolaca);
										numeroPolaca++;
									}
		  
		  }
		  | factor {printf("\n---------------------->termino - factor");};

factor :    ID {printf("\n---------------------->factor - id");
				if( _aux == -2 )
				{printf("\n!!!!!!lectura nomarl de variables");
					insertar_en_polaca_id($<stringValue>1, numeroPolaca);
					numeroPolaca++;
				}
				if( _aux == -1 )
				{
					strcpy(_auxID,yylval.stringValue);
					printf("\n!!!!!!me quedo con la variable del ciclo %s",_auxID);
				}
				if( _aux >= 0 )
				{printf("\n!!!!!!comparo si la variable esta en el item de la lista");
					if(strcmp(_auxID,yylval.stringValue) == 0)
					{printf("\n!!!!!!coincidencia encontrada");
						_aux++;
						printf("\n!!!!!!coincidencia encontrada: %d", _aux);
					}
						
				}
				

		}
		
		  | CTE {
				if( _aux < 0 )
				{printf("\n---------------------->factor - cte");
				 char* nombre_cte_int = guardar_cte_int(atoi($<stringValue>1));
				 insertar_en_polaca_cte_int(atoi($<stringValue>1), numeroPolaca);
				 numeroPolaca++;
				}
				
			  
				
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
		
lista : lista COMA factor {printf("\n---------------------->lista");_contLong++;}
		| factor {printf("\n---------------------->lista - factor");};
		
ciclo_especial : WHILEE {insertar_en_polaca_operador("0", numeroPolaca);numeroPolaca++; 
						 insertar_en_polaca_operador("ice", numeroPolaca);numeroPolaca++;
						 insertar_en_polaca_operador(":=", numeroPolaca);numeroPolaca++;
						 insertar_en_polaca_operador("ET", numeroPolaca);
						 //insertar_en_polaca_etiqueta_apilar(numeroPolaca);numeroPolaca++;
						  printf("\n!!!!!!!!me guardo el id %d para la etiqueta del while",numeroPolaca);
						 ponerEnPila(pila, numeroPolaca);numeroPolaca++;
						 insertar_en_polaca_operador("ice", numeroPolaca);numeroPolaca++;
						 iterador = 0;
						 //prendo bandera para contar la cantidad de coincidencias
						 _aux++;
						 }
				 ID {
				     
					 strcpy(_auxID,yylval.stringValue);
					 //insertar_en_polaca_id(_auxID, numeroPolaca);
					 printf("\nvariable a buscar: %s",_auxID);
					//numeroPolaca++;
					 _aux++;}
				 IN CORA lista_expre
				 CORC {//desapilar_e_insertar_en_celda(numeroPolaca+2);
						
						 
						char str[30];
						itoa(_auxContador+1,str,10);
						 printf("\n!!!!!insertando la cantidad de iteraciones: %d en el id %d",_auxContador+1,numeroPolaca);
					insertar_en_polaca_operador(str, numeroPolaca);numeroPolaca++;
					 _aux = -2;_auxContador = 0;
					 insertar_en_polaca_operador("CMP", numeroPolaca);numeroPolaca++;
					 insertar_en_polaca_operador("BGT", numeroPolaca);numeroPolaca++;
					  printf("\n!!!!!!!!me guardo el id %d para la BGT del while",numeroPolaca);
					 //desapilar_e_insertar_en_celda(numeroPolaca);
					 //desapilar_e_insertar_en_celda(numeroPolaca+2);
					 //insertar_en_polaca_salto_condicion(numeroPolaca);
					 //numeroPolaca += 2;
					 ponerEnPila(pila, numeroPolaca);numeroPolaca++;
					 }
			     DO programa {insertar_en_polaca_operador("1", numeroPolaca);numeroPolaca++; 
						 insertar_en_polaca_operador("ice", numeroPolaca);numeroPolaca++;
						 insertar_en_polaca_operador("+", numeroPolaca);numeroPolaca++;
						 insertar_en_polaca_operador("ice", numeroPolaca);numeroPolaca++;
						 insertar_en_polaca_operador(":=", numeroPolaca);numeroPolaca++;}
				 ENDWHILE {printf("\n---------------------->ciclo especial");
				 desapilar_e_insertar_en_celda(numeroPolaca+2);
				 insertar_bi_desapilar(numeroPolaca);numeroPolaca += 2;
				 // desapilar_e_insertar_en_celda(numeroPolaca);
				  printf("\n!!!!!!!!saco el numero guardado en la pila %d",sacarDePila(pila));
				 //int valor_celda = sacarDePila(pila);
				//strcpy(gci[sacarDePila(pila)].simbolo, constante_string);
				 };

lista_expre : lista_expre COMA{
								if (_aux > 0){
									_auxContador++;
									_aux = 0;
								}
									
		
							}	
			expresion {printf("\n---------------------->lista de expresiones ");}
			| expresion {printf("\n---------------------->expresion - inicio lista");}
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