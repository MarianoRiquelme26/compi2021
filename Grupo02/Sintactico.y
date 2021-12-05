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
int _not = 0;
int celdaCondicionUno = -1;
int cantcomp = 1;
int _or = 0;
int vecOr[4];
int vecOr2[2];
//int contVarAux = -1;
int _polOr = 0;	
int _swapOr = 0;	
int _swapCel = 0;	
int valorIn = 0;
int _cantElem = 0;


%}
%union 
{ 
    int intValue; 
    float floatValue; 
    char *stringValue; 
} 
%start startSimbol
//%token programa
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

%token OP_MAYOR
%token OP_MAYORIGUAL       
%token OP_MENORIGUAL         
%token OP_IGUAL             
%token OP_MENOR             
%token OP_DISTINTO 

%token IF
%token THEN
%token THENS
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

startSimbol : /*{/*
			initArray(&array_tipos_variables);
			initArray(&array_nombres_variables);
			crearTabla();
			crearPolaca();

			}*/
			programa {printf("\n---------------------->****************** START DETECTADO");
			//guardar_ts();
			//guardar_gci(numeroPolaca);
			//freeArray(&array_tipos_variables);
			//freeArray(&array_nombres_variables);
			//guardar_variables_ts();
			//freeArray(&array_nombres_variables);
				//freeArray(&array_tipos_variables);
				
				//initArray(&array_nombres_variables);
				//initArray(&array_tipos_variables);	
			
			generaAssembler(numeroPolaca);};

programa : programa sentencia {printf("\n----------------------"); /*generaAssembler(numeroPolaca);*/}
		 |  sentencia  {printf("\n----------------------");/*generaAssembler(numeroPolaca);*/};
		
		
sentencia : asignacion {printf("\n---------------------->sentencia - asignacion");}
		  | salida {printf("\n---------------------->sentencia - salida");}
		  | entrada {printf("\n---------------------->sentencia - entrada");}
		  | iteracion {printf("\n---------------------->sentencia - iteracion");}
		  | seleccion {printf("\n---------------------->sentencia - seleccion");}
		  |	declaracion {printf("\n---------------------->sentencia - declaracion");}
		  | COMEN {printf("\n");}
		  | ID OP_ASIG LONG{_contLong = 0;_aux = 0;}
		  PARA lista PARC { printf("\n---------------------->sentencia - tema especial - long");
							if(!existe_simbolo($<stringValue>1)){
								printf("VARIABLE %s NO DEFINIDA",$<stringValue>1);
								yyerror("");
							}
		  
							char str[30];
							itoa(_contLong+1,str,10);
							//char str2[40] = "_";
							char str2[40] = "@cte";
							strcat(str2,str);
							insertar_en_polaca_id(str2, numeroPolaca);
							numeroPolaca++;
							insertar_en_polaca_id($<stringValue>1, numeroPolaca);
							numeroPolaca++;
							insertar_en_polaca_operador(":=", numeroPolaca);
							numeroPolaca++;
							_aux = -2;
							ivecLong++;
							vecLong[ivecLong] = _contLong+1;
							}
		  | ciclo_especial {printf("\n---------------------->sentencia - tema especial - cilco especial");}
		  | ENTER {printf("\n");};

asignacion : ID OP_ASIG expresion {	printf("\n---------------------->asignacion donde rompe");									
									//insertar_en_polaca_id($<stringValue>1, numeroPolaca);
									//numeroPolaca++;
									//insertar_en_polaca_operador(":=", numeroPolaca);
									//numeroPolaca++;
									/*SE JUNTA CON EL DESARROLLO DE EMI PARA LAS VALICACIONES*/	
									switch(verificar_asignacion($<stringValue>1)){	
									  case 1:     printf("\nNO SE DECLARO LA VARIABLE - %s - EN LA SECCION DE DEFINICIONES-asignacion\n",$<stringValue>1);	
												  yyerror("\nERROR DE ASIGNACION\n");	
												  break;	
									  case 2:     insertar_en_polaca_id($<stringValue>1, numeroPolaca);	
												  numeroPolaca++;	
												  insertar_en_polaca_operador(":=", numeroPolaca);	
												  numeroPolaca++;	
												  break;	
									  case 3:     printf("\nERROR DE SINTAXIS, ASIGNACION ERRONEA, TIPOS DE DATOS INCORRECTOS.\n"); 	
												  printf("\nUSTED ESTA INTENTANDO ASIGNAR UNA CONSTANTE %s A UNA VARIABLE %s \n", ultima_expresion, simbolo_busqueda.tipo_dato);	
												  yyerror("\nERROR DE ASIGNACION\n");	
												  break;	
									}
			
			}//ESTO ANTES ESTABA DESOCMENTADO, LO DESCOMENTO
			|ID OP_ASIG CTE_S {	//printf("\n---------------------->asignacion constante string donde no rompe: %s\n",$<stringValue>3);	
								//guardar_cte_string($<stringValue>3);
								strcpy(idAux,yylval.stringValue);
								char mensaje[50] = "_";
								strcat(mensaje,idAux);
								guardar_cte_string(mensaje);
								/*insertar_en_polaca_id(const_string_sin_espacio, numeroPolaca);
								numeroPolaca++;
								insertar_en_polaca_id($<stringValue>1, numeroPolaca);
								numeroPolaca++;
								insertar_en_polaca_operador(":=", numeroPolaca);
								numeroPolaca++;
								/**/
								ultima_expresion = "string";	
								switch(verificar_asignacion($<stringValue>1)){	
									  case 1:     printf("\nNO SE DECLARO LA VARIABLE - %s - EN LA SECCION DE DEFINICIONES\n",$<stringValue>3);	
												  yyerror("\nERROR DE ASIGNACION");	
												  break;	
									  case 2:     insertar_en_polaca_id(const_string_sin_espacio, numeroPolaca);
												  numeroPolaca++;	
												  insertar_en_polaca_id($<stringValue>1, numeroPolaca);	
												  numeroPolaca++;	
												  insertar_en_polaca_operador(":=", numeroPolaca);	
												  numeroPolaca++;	
												  break;	
									  case 3:     printf("\nERROR DE SINTAXIS, ASIGNACION ERRONEA, TIPOS DE DATOS INCORRECTOS.\n"); 	
												  printf("\nUSTED ESTA INTENTANDO ASIGNAR UNA CONSTANTE %s A UNA VARIABLE %s \n", ultima_expresion, simbolo_busqueda.tipo_dato);	
												  yyerror("\nERROR DE ASIGNACION");	
												  break;	
									}	
				}	
			;
		
salida :    DISPLAY factor {printf("\n---------------------->salida - display");
					//COMENTO ESTO PORQ SE ME ESTABA DUPLICANDO
					//insertar_en_polaca_id($<stringValue>2, numeroPolaca);
					//numeroPolaca++;
					insertar_en_polaca_operador("DISPLAY", numeroPolaca);
					numeroPolaca++;
					//printf("\n-----------------------------INSERTO LAS DOS COSAS YA, ESTOY EN EL SIGUIENTE INDICE %d\n",numeroPolaca+10); 	
					}
		  | DISPLAY CTE_S {printf("\n---------------------->salida - display");
					printf("\n---------------------->factor cte STRING");
					strcpy(idAux,yylval.stringValue);
					char mensaje[50] = "_";
					strcat(mensaje,idAux);
					//VALIDO QUE NO EXISTA LA CONSTANTE PARA NO METERLA EN LA TABLA DOS VECES
					if (existe_simbolo(mensaje) == FALSE)
						guardar_cte_string(mensaje);
					
					//insertar_en_polaca_id($<stringValue>2, numeroPolaca); veo si me inserta bien 
					insertar_en_polaca_id(const_string_sin_espacio, numeroPolaca);
					numeroPolaca++;
					insertar_en_polaca_operador("DISPLAY", numeroPolaca);
					numeroPolaca++;
					};
		  
entrada:    GET ID {printf("\n---------------------->entrada");
					if(!existe_simbolo($<stringValue>2)){
							printf("VARIABLE %s NO DEFINIDA",$<stringValue>2);
							yyerror("");
					  }
					insertar_en_polaca_id($<stringValue>2, numeroPolaca);
					numeroPolaca++;
					insertar_en_polaca_operador("GET", numeroPolaca);
					numeroPolaca++;};

expresion : expresion OP_SUM termino {	if(_aux == -2)
										{
										printf("\n---------------------->expresion - SUM: agrego @aux%d",contVarAux+1);
										insertar_en_polaca_operador("+", numeroPolaca);
										numeroPolaca++;
										contVarAux+=1;
										}

		   }
		  | expresion OP_RES termino {
										if( _aux == -2 )
										{			  
											printf("\n---------------------->expresion - RES: agrego @aux%d",contVarAux+1);
											insertar_en_polaca_operador("-", numeroPolaca);
											numeroPolaca++;
											contVarAux+=1;
										}
		   }
		  | termino {printf("\n---------------------->expresion - termino");};
		  
iteracion: WHILE {insertar_en_polaca_etiqueta_apilar(numeroPolaca); numeroPolaca++;}
		   condicion START programa {desapilar_e_insertar_en_celda(numeroPolaca+2);}
		   END {printf("\n---------------------->iteracion - while");
		        insertar_bi_desapilar(numeroPolaca);numeroPolaca += 2;
				};

seleccion :   IF condicion {vecOr2[1] = numeroPolaca;
					if(_or == 1){	
						vecOr[0] = numeroPolaca;	
						vecOr[1] =  desapilar_e_insertar_en_celda(numeroPolaca);	
						_or = 0;	
						_swapOr = 1;	
						_swapCel = vecOr[1];
					}	
				}THEN programa 					    	
					{//desapilar_e_insertar_en_celda(numeroPolaca+2);
					//vecOr2[1] = numeroPolaca;
					//vecOr2[1] = sacarDePila(pila);
					//ponerEnPila(pila,numeroPolaca);
					 while(cantcomp != 0){
						 vecOr[0] = numeroPolaca+2;
												vecOr[1] = desapilar_e_insertar_en_celda(numeroPolaca+2);
												if(_swapOr == 1){intercambiarOr(vecOr[1],_swapCel); _swapOr = 0;}
												cantcomp--;
												} 
												
												cantcomp = 1;
					//ponerEnPila(pila,numeroPolaca+1);
					 insertar_en_polaca_salto_condicion("BI", numeroPolaca,_not);
					 numeroPolaca += 2;
					 }
			  ELSE /*
				  {
				if(_or == 1){
					vecOr[0] = numeroPolaca;
					vecOr[1] =  desapilar_e_insertar_en_celda(numeroPolaca);
					_or = 0;
				}
				
			}*/
			programa
			  

			  ENDIF {printf("\n---------------------->seleccion - if");
								   //desapilar_e_insertar_en_celda(numeroPolaca);
								   while(cantcomp != 0){
												vecOr[2] = numeroPolaca;
												vecOr[3] =  desapilar_e_insertar_en_celda(numeroPolaca);
												cantcomp--;} 
												cantcomp = 1;
												//correcionLogicaDelOr(vecOr[1]+10,vecOr[0],0,0,0);
												vecOr[0]= vecOr[1] = vecOr[2] = vecOr[3] = 0;
								   }
			| IF condicion THENS {
				if(_or == 1){
					vecOr[2] = numeroPolaca;
					vecOr[3] =  desapilar_e_insertar_en_celda(numeroPolaca);
					//_or = 0;
				}
				
			}
			programa ENDIF {
												//desapilar_e_insertar_en_celda(numeroPolaca);
												//desapilar_e_insertar_en_celda(celdaCondicionUno);
												while(cantcomp != 0){
													vecOr[0] = numeroPolaca;
													vecOr[1] =  desapilar_e_insertar_en_celda(numeroPolaca);
													cantcomp--;
													} 
													cantcomp = 1;
												if(_or == 1)
												{correcionLogicaDelOr(vecOr[1],vecOr[2],vecOr[3],vecOr[0],1);
													_or = 0;
												}
												
												//vecOr[0]= vecOr[1] = vecOr[2] = vecOr[3] = 0;
												}
			;

condicion :   PARA condicion {cantcomp++;}
			  AND comparacion PARC {printf("\n---------------------->condicion");}
			| PARA condicion 
			{
			if(_or == 1){
					//vecOr[0] = numeroPolaca;
					//vecOr[1] =  desapilar_e_insertar_en_celda(numeroPolaca);
					_or = 0;
				}
			}
			OR {_or = 1; _polOr = numeroPolaca-2;  printf("la condicion OR esta en %d", _polOr);//vecOr2[0] = 1;

			}
			 comparacion PARC {printf("\n---------------------->condicion"); invertirCondicion(_polOr);}
			| PARA NOT {_not = 1;} condicion PARC	{printf("\n---------------------->condicion");}
			| comparacion 	{	printf("\n---------------------->condicion");								
			};
			
comparacion: expresion comparador expresion {
											 insertar_en_polaca_operador("CMP", numeroPolaca); 
											 numeroPolaca++;
											 //celdaCondicionUno = numeroPolaca;
											 insertar_en_polaca_salto_condicion(operadorAux,numeroPolaca,_not);
											 vecOr[0] = numeroPolaca;
											 _not = 0;
											 vecOr2[0] = numeroPolaca;
											 numeroPolaca += 2;
											 }
			|PARA expresion comparador expresion PARC{printf("\n---------------------->3 - condicion");
													  insertar_en_polaca_operador("CMP", numeroPolaca);
													  numeroPolaca++;
													  insertar_en_polaca_salto_condicion(operadorAux, numeroPolaca,_not);
													  vecOr[0] = numeroPolaca;
													  _not = 0;
													  numeroPolaca += 2;
													  }

comparador: OP_MAYORIGUAL       {printf("\n---------------------->OP_MAYORIGUAL");
												
									strcpy(operadorAux,">=");

								}
    | OP_MENORIGUAL         {printf("\n---------------------->OP_MENORIGUAL");

									strcpy(operadorAux,"<=");

								}
    | OP_IGUAL              {printf("\n---------------------->OP_IGUAL");

									strcpy(operadorAux,"==");

		
								}
    | OP_MAYOR             {printf("\n---------------------->OP_MAYOR");

									strcpy(operadorAux,">");

								}
    | OP_MENOR              {printf("\n---------------------->OP_MENOR");

									strcpy(operadorAux,"<");

								}
    | OP_DISTINTO            {printf("\n---------------------->OP_DISTINTO");
	
									strcpy(operadorAux,"!=");

								}
    ;	



termino   : termino OP_MUL factor {//CON LA BANDERA _aux INDICO QUE NO ESTOY LEVANTANDO VALORES
								   //DEL CICLO ESPECIAL Y TENGO QUE TENERLOS EN CUENTA
									if( _aux == -2 )
									{
										printf("\n---------------------->MULTIPLICACION: agrego @aux%d",contVarAux+1);
										insertar_en_polaca_operador("*", numeroPolaca);
										numeroPolaca++;
										/*GENERO LAS VARAIBLES AUXILIARES A USAR
										char varAuxi[100] = "@aux";
										char str[30];
										itoa(contVarAux,str,10);
										//strcat(str,'\0');
										strcat(varAuxi,str);
										printf("\t %s\n",varAuxi);
										insertArray(&array_nombres_variables,varAuxi);
										//conadorDeclaracionesV += 1;
										insertArray(&array_tipos_variables,"real");
										//conadorDeclaracionesT += 1;
										contVarAux+=1;*/
										contVarAux+=1;
									}
									
		  }
		  | termino OP_DIV factor {
									if( _aux == -2 )
									{
										printf("\n---------------------->DIVISION: agrego @aux%d",contVarAux+1);
										insertar_en_polaca_operador("/", numeroPolaca);
										numeroPolaca++;
										/*GENERO LAS VARAIBLES AUXILIARES A USAR
										char varAuxi[100] = "@aux";
										char str[30];
										itoa(contVarAux,str,10);
										strcat(varAuxi,str);
										printf("**********quiero insertar en la tabla de simbolos:%s",varAuxi);
										insertArray(&array_nombres_variables,varAuxi);
										conadorDeclaracionesV += 1;
										insertArray(&array_tipos_variables,"real");
										conadorDeclaracionesT += 1;
										contVarAux+=1;*/
										contVarAux+=1;
									}
		  
		  }
		  | factor {printf("\n---------------------->termino - factor");};

factor :    ID {//printf("\n---------------------->factor - id");
				if(!existe_simbolo($<stringValue>1)){	
                  printf("\nNO SE DECLARO LA VARIABLE - %s - EN LA SECCION DE DEFINICIONES-factor\n",$<stringValue>1);	
                  yyerror("\nERROR DE ASIGNACION\n");	
				}

				if( _aux == -2 )
				{//printf("\n!!!!!!lectura nomarl de variables");
					insertar_en_polaca_id($<stringValue>1, numeroPolaca);
					numeroPolaca++;/*
					if(!existe_simbolo($<stringValue>1)){	
                  printf("\nNO SE DECLARO LA VARIABLE - %s - EN LA SECCION DE DEFINICIONES-factor\n",$<stringValue>1);	
                  yyerror("\nERROR DE ASIGNACION\n");	
				}	
				ultima_expresion = simbolo_busqueda.tipo_dato;	*/
				}
				if( _aux == -1 )
				{
					strcpy(_auxID,yylval.stringValue);
				}
				if( _aux >= 0 )
				{
					if(strcmp(_auxID,yylval.stringValue) == 0)
					{
						_aux++;
					}
						
				}
				

		}
		
		  | CTE {
				if( _aux < 0 )
				{printf("\n---------------------->factor - cte");
				 char* nombre_cte_int = guardar_cte_int(atoi($<stringValue>1));
				 ultima_expresion = "integer";
				 insertar_en_polaca_cte_int(atoi($<stringValue>1), numeroPolaca);
				 numeroPolaca++;
				}
				
			  
				
		}
		 |CTE_R {
					printf("\n---------------------->factor cte real");
					float valor = atof($<stringValue>1);
					ultima_expresion = "real"; 
					char* nombre_cte_float = guardar_cte_float(valor);
					//VOY INSETAR LA CONSTANTE REAL CON EL NOMBRE DE LA VARIABLE PARA FICILITAR EL ASSEMBLER
					//insertar_en_polaca_cte_real(atof($<stringValue>1), numeroPolaca);
					insertar_en_polaca_id(nombre_cte_float, numeroPolaca);
					
					numeroPolaca++;
		 }
		 	 
		 
		 | PARA expresion PARC {printf("\n---------------------->factor - expresion");};
		 
declaracion : DIM CORA listav CORC AS CORA listat CORC 
			{ /*ESTO SE MIGRA ANTES DE CREAR EL ASSEMBLER
			printf("\n---------------------->ESTOY GUARDANDO LA TABLA DE SIMBOLOS");*/
				guardar_variables_ts();
				/*freeArray(&array_nombres_variables);
				freeArray(&array_tipos_variables);
				
				initArray(&array_nombres_variables);
				initArray(&array_tipos_variables);*/
				printf("\n---------------------->TERMINE GUARDANDO LA TABLA DE SIMBOLOS");
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
		
ciclo_especial : WHILEE {insertar_en_polaca_etiqueta_apilar(numeroPolaca); numeroPolaca++;}
				 ID {if(!existe_simbolo(yylval.stringValue)){
							printf("VARIABLE %s NO DEFINIDA EN WHILEE",yylval.stringValue);
							yyerror("");
					  }
					 if(valorIn == 0){strcpy(_auxID,yylval.stringValue); valorIn = 1;}}/*
				     
					 strcpy(_auxID,yylval.stringValue);
					 insertar_en_polaca_id(_auxID, numeroPolaca);
					 numeroPolaca++;
					 //insertar_en_polaca_id(_auxID, numeroPolaca);
					 printf("\nvariable a buscar: %s",_auxID);
					//numeroPolaca++;
					 _aux++;}*/
				 IN CORA lista_expre {//insertar_en_polaca_id("@aux",numeroPolaca);
								insertar_en_polaca_id("@auxCE",numeroPolaca);
								numeroPolaca++;
								insertar_en_polaca_operador(":=", numeroPolaca);
								numeroPolaca++;
								insertar_en_polaca_operador(_auxID, numeroPolaca);
								numeroPolaca++;
								insertar_en_polaca_operador("CMP", numeroPolaca);
								numeroPolaca++;
								strcpy(operadorAux,"==");
								int i;
								for(i = 0; i< _cantElem; i++){
								desapilar_e_insertar_en_celda(numeroPolaca+2);}
								_cantElem = 0;
								insertar_en_polaca_salto_condicion(operadorAux, numeroPolaca, 0);
								numeroPolaca += 2;
								}
				 CORC 
			     DO programa 
				 ENDWHILE {printf("\n---------------------->ciclo especial");
				 desapilar_e_insertar_en_celda(numeroPolaca+2);
				 insertar_bi_desapilar(numeroPolaca);numeroPolaca += 2;
				 // desapilar_e_insertar_en_celda(numeroPolaca);
				 //int valor_celda = sacarDePila(pila);
				//strcpy(gci[sacarDePila(pila)].simbolo, constante_string);
				 };

lista_expre : lista_expre COMA{
								if (_aux > 0){
									_auxContador++;
									_aux = 0;
								}
								falgCicloEspecial = 1;
								insertar_en_polaca_id("@auxCE",numeroPolaca);
								numeroPolaca++;
								insertar_en_polaca_operador(":=", numeroPolaca);
								numeroPolaca++;
								insertar_en_polaca_operador(_auxID, numeroPolaca);
								numeroPolaca++;
								insertar_en_polaca_operador("CMP", numeroPolaca);
								numeroPolaca++;
								strcpy(operadorAux,"!=");
								insertar_en_polaca_salto_condicion(operadorAux, numeroPolaca, 0);
								numeroPolaca += 2;
								_cantElem++;
							}	
			expresion {printf("\n---------------------->lista de expresiones ");}
			| expresion {printf("\n---------------------->expresion - inicio lista"); }
			;

%%

int main (int argc,char *argv[]){

 if ((yyin=fopen(argv[1],"rt"))==NULL)
 {
  	printf("\nNo se puede abrir el archivo: %s\n",argv[1]);
 }
 else{
	freeArray(&array_tipos_variables);
	freeArray(&array_nombres_variables);
	initArray(&array_tipos_variables);
	initArray(&array_nombres_variables);
   // crearTabla();
	crearPolaca();
	yyparse();
	//guardar_ts();
	guardar_gci(numeroPolaca);
    //freeArray(&array_tipos_variables);
	//freeArray(&array_nombres_variables);
	//generarETAssembler();
	//generarDataAssembler();
	//generaAssembler(numeroPolaca);
	//yyparse();
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