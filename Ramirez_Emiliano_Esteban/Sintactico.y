%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "funciones.c"

int yystopparser=0;
FILE *yyin;
int yyerror();
int yylex();
char *yyltext;



typedef struct
{
    char token[20];
    char lexema[20];
} t_info;

typedef struct s_nodo_lista
{
    t_info dat;
    struct s_nodo_lista* sig;
} t_nodo_lista;
typedef t_nodo_lista* t_lista;

typedef int (*t_cmp)(const void*,const void*);
    
int comp(const void* d1,const void *d2)
{
    t_info *dat1=(t_info*)d1;
    t_info *dat2=(t_info*)d2;
	return strcmp(dat1->lexema,dat2->lexema);
}
t_lista lista1;
t_info dat;

int contadorLetrastID = 0;
int contadorLetrastCT = 0;
int conadorDeclaracionesV = 0;
int conadorDeclaracionesT = 0;

void listaCrear(t_lista* pl)
{
    *pl=NULL;
}
int listaVacia(const t_lista* pl)
{
    return !*pl;
}
void listaVaciar(t_lista* pl,t_info* dat)
{
	FILE *pt;
    char* cad;
    char lineaID[contadorLetrastID+1];
	char lineaCTE[contadorLetrastCT+1];
	strcpy(lineaID,"");
	strcpy(lineaCTE,"");
    t_nodo_lista* elim;
	pt=fopen("ts.txt","wt");
    if(!pt)
    {
        puts("No se pudo abrir archivo");
        exit(0);
    }
	
    while(*pl)
    {
        elim=*pl;
		*dat=elim->dat;
		if(strcmp(dat->token,"ID")==0)
		{
			strcat(lineaID,",");
			strcat(lineaID,dat->lexema);
		}
			
		if(strcmp(dat->token,"CTE")==0)
		{
			strcat(lineaCTE,",");
			strcat(lineaCTE,dat->lexema);
		}
			
        *pl=elim->sig;
        free(elim);
		
    }
	
	cad = lineaID;
	*cad = ' ';
	cad = lineaCTE;
	*cad = ' ';
	
	fprintf(pt,"token: ID\t lexemas: %s\n",lineaID);
	fprintf(pt,"token: CTE\t lexemas: %s\n",lineaCTE);
	fclose(pt);
}

int listaBuscar(const t_lista* pl,t_info* dat,t_cmp comp)
{
    while(*pl){
		if(comp(dat,&(*pl)->dat)==0)
		{
			return 1;
		}
		pl=&(*pl)->sig;
	}
    
    return 0;
}

int insertarLista(t_lista* pl,t_info* dat)
{
    t_nodo_lista* nuevo;

    nuevo=(t_nodo_lista*)malloc(sizeof(t_nodo_lista));
    if(!nuevo)
        return 0;
    nuevo->dat=*dat;
    nuevo->sig=*pl;
    *pl=nuevo;
    return 1;
}


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

asignacion : ID OP_ASIG expresion {printf("\n---------------------->asignacion");};
		
salida :    DISPLAY factor {printf("\n---------------------->salida - display");}
		  | DISPLAY CTE_S {printf("\n---------------------->salida - display");};
		  
entrada:    GET ID {printf("\n---------------------->entrada");};

expresion : expresion OP_SUM termino {printf("\n---------------------->expresion - SUM");}
		  | expresion OP_RES termino {printf("\n---------------------->expresion - RES");}
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


termino   : termino OP_MUL factor {printf("\n---------------------->termino");}
		  | termino OP_DIV factor {printf("\n---------------------->termino");}
		  | factor {printf("\n---------------------->termino - factor");};

factor :    ID {printf("\n---------------------->factor - id");}
		  | CTE {
				printf("\n---------------------->factor - cet");
				strcpy(dat.token,"CTE");
				strcpy(dat.lexema,yylval.stringValue);
				if(!listaBuscar(&lista1,&dat,comp)){
					insertarLista(&lista1,&dat);
				contadorLetrastCT += strlen(yylval.stringValue)+1;
				
				
				char* nombre_cte_int = guardar_cte_int(atoi($<stringValue>1));
	}
			 }
		 |CTE_R {
					printf("\n---------------------->factor cet real");
					strcpy(dat.token,"CTE");
					strcpy(dat.lexema,yylval.stringValue);
					if(!listaBuscar(&lista1,&dat,comp)){
						insertarLista(&lista1,&dat);
					contadorLetrastCT += strlen(yylval.stringValue)+1;
					
					
					float valor = atof($<stringValue>1);
					char* nombre_cte_float = guardar_cte_float(valor);
					}
		 }
		 | PARA expresion PARC {printf("\n---------------------->factor - expresion");};
		 
declaracion : DIM CORA listav CORC AS CORA listat CORC 
			{ 
				int controlDeclaracion = conadorDeclaracionesV - conadorDeclaracionesT;
				conadorDeclaracionesV = 0;
				conadorDeclaracionesT = 0;
				if(controlDeclaracion != 0)
					puts("NO COINCIDEN LA CANTIDAD DE PARAMETROS CON LA CANTIDAD DE TIPOS");
					
					
					
				guardar_variables_ts();
				freeArray(&array_nombres_variables);
				initArray(&array_nombres_variables);
			};

listav : listav COMA ID 
		{
			printf("\n---------------------->lista de variables");
			strcpy(dat.token,"ID");
			strcpy(dat.lexema,yylval.stringValue);
			if(!listaBuscar(&lista1,&dat,comp)){
				insertarLista(&lista1,&dat);
				contadorLetrastID += strlen(yylval.stringValue)+1;
				conadorDeclaracionesV += 1;
			}
			
			insertArray(&array_nombres_variables,$<stringValue>3);
		}
		| ID 
		{	
			printf("\n---------------------->lista de variables - id");
			strcpy(dat.token,"ID");
			strcpy(dat.lexema,yylval.stringValue);
			if(!listaBuscar(&lista1,&dat,comp)){
				insertarLista(&lista1,&dat);
				contadorLetrastID += strlen(yylval.stringValue)+1;
				conadorDeclaracionesV += 1;
			}
			
			insertArray(&array_nombres_variables,$<stringValue>1);
		}
		;
listat : listat COMA TIPO 
		{
			printf("\n---------------------->lista tipos");
			conadorDeclaracionesT += 1;
			
			strcpy(tipo_dato,$<stringValue>3);
		}
		| TIPO 
		{
			printf("\n---------------------->lista TIPOS - corte");
			conadorDeclaracionesT += 1;
			
			strcpy(tipo_dato,$<stringValue>1);
		};
		
lista : lista COMA factor {printf("\n---------------------->lista");}
		| factor {printf("\n---------------------->lista - factor");};
		
ciclo_especial : WHILE ID IN CORA lista_expre CORC DO programa ENDWHILE {printf("\n---------------------->ciclo especial");};

lista_expre : lista_expre COMA expresion {printf("\n---------------------->lista de expresiones");}
			| expresion {printf("\n---------------------->expresion - corte");}
			;

%%

int main (int argc,char *argv[]){

 listaCrear(&lista1);

 if ((yyin=fopen(argv[1],"rt"))==NULL)
 {
  	printf("\nNo se puede abrir el archivo: %s\n",argv[1]);
 }
 else{
	initArray(&array_nombres_variables);
    crearTabla();
	yyparse();
	guardar_ts();
    freeArray(&array_nombres_variables);
 }
 fclose(yyin);

 listaVaciar(&lista1,&dat);
 return 0;
}

int yyerror(void)
	{ 
 	  printf("Syntax Error\n");
	  system("Pause");
          exit (1);
	}