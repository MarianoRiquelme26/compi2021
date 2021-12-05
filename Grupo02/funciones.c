#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>
#include "array.c"
#include "pila.c"
#define INITIAL_CAPACITY 1
#define MAX_STRING_LENGTH 30
#define TABLA_SIMBOLOS "ts.txt"
#define POLACA "intermedia.txt"
#define ASSEMBLER "final.asm"
#define TAM_TABLA 350
#define TAM_POLACA 350
#define TAM_PILA 50
#define TAM_NOMBRE 32
#define TRUE 1
#define FALSE 0
#define SUCCESS 99
#define NOT_SUCCESS -99

//funciones tabla simbolos
void crearTabla();
void guardar_variables_ts();
char* guardar_cte_int(int valor);
void guardar_cte_string(char * valor);
char* guardar_cte_float(float valor);
void guardar_ts();
int existe_simbolo(char * comp);
int verificar_asignacion(char * valor);
int existe_between = 0;
int falgCicloEspecial = 0;
int etiquetas[50];
char * ultima_expresion;

//funciones polaca inversa
void crearPolaca();
void insertar_en_polaca_cte_int(int cte, int num);
void insertar_en_polaca_cte_real(float cte_real, int num);
void insertar_en_polaca_id(char *valor, int num);
void insertar_en_polaca_operador(char * valor, int num);
//void insertar_en_polaca_salto_condicion(int num);
void insertar_en_polaca_salto_condicion(char *simbolo, int num, int negado);
void insertar_en_polaca_etiqueta_apilar(int num);
int desapilar_e_insertar_en_celda(int num);
void insertar_bi_desapilar(int num);
void guardar_gci(int cantidad);
//Esta funcion ya no se utiliza mas
char* ObtenerBranchComparador(char*);
char * negarComparador(char* comparador);
void correcionLogicaDelOr(int v1, int c1, int v2, int c2,int flagInvertir);
int noExistEtiqueta(int cantEtiq,char* simbolo);
//funciones assembler
void generaAssembler(int cantidad);
void generarETAssembler();
void generarDataAssembler();
void generarCODEAssembler();
void generarETFinAssembler();
int esOperador(char *simbolo);
void intercambiarOr(int vecOr, int _swapCel);
void invertirCondicion(int _polOr);
//funciones complementarias
char* concat(const char *s1, const char *s2);
char* conversorComparadorAssem(char* comparador);


typedef struct {
	char nombre[TAM_NOMBRE];
	char tipo_dato[TAM_NOMBRE];
	char valor[TAM_NOMBRE];
	int longitud;
} simbolo;

simbolo ts[TAM_TABLA];
simbolo simbolo_busqueda;
//simbolo ts_var[TAM_TABLA];//tabla temporal utilizada para poder realizar los display de forma correcto

typedef struct {
	char simbolo[TAM_NOMBRE];
	int numero;
} polaca;

typedef struct
{
    int numeroPolaca[TAM_PILA];
    int tope;
}tPila;


t_pila pVariables;
/*
typedef struct {
	char simbolo[TAM_NOMBRE];
	int tope;
} tPilaAssembler;*/

// funciones de pila
void crearPila(tPila *p);
int pilaLlena(tPila *p);
int pilaVacia(tPila *p);
int ponerEnPila(tPila *p, int num);
int sacarDePila(tPila *p);
//int ponerEnPila_assembler(tPilaAssembler *p);
//int sacarDePila_assembler(tPilaAssembler *p);

tPila pila[TAM_PILA];
polaca gci[TAM_POLACA];
//tPilaAssembler pila_assembler[TAM_POLACA];
tPila pilaAss[TAM_PILA];

FILE * file;
FILE * filePolaca;
FILE * fileAssembler;
int between_flag = 0;
int cant_elem_ts = 0;
int cantidad_cuerpos;
int cantidad_bloques = 0;
char tipo_dato[30];
char str_aux[30];
char * ultima_expresion;
char * ultimo_comparador;

char * ultimo_operador;

int contadorCteString = 0;
int contVarAux = -1;
int vecLong[30];
int ivecLong = -1;
char const_string_sin_espacio[100];

void guardar_variables_ts(){
  int i = 0;
   //printf("\nGUARDANDO TABLA DE SIMBOLOS..............CANT ELE: %d.....\n",array_nombres_variables.used);
  for(i; i<array_nombres_variables.used; i++){
    if(cant_elem_ts<=TAM_TABLA && !existe_simbolo(array_nombres_variables.array[i])){
	   //printf("valor en la tabla: %s, indice: %d\n",array_nombres_variables.array[i],i);
      strcpy(ts[cant_elem_ts].nombre,array_nombres_variables.array[i]);
      ts[cant_elem_ts].longitud = 0;
      strcpy(ts[cant_elem_ts].tipo_dato,array_tipos_variables.array[i]);
      strcpy(ts[cant_elem_ts].valor,"-");
      cant_elem_ts++;
    }
    else{ // printf("Entro al else valor en la tabla: %s, indice: %d\n",array_nombres_variables.array[i],i);
      if(cant_elem_ts>TAM_TABLA){
        printf("TABLA DE SIMBOLOS LLENA.\n");
        exit(1);
      }
      else{
        printf("VARIABLE %s DECLARADA PREVIAMENTE\n", array_nombres_variables.array[i]);
        exit(1);
      }
    }
  }
}

void intercambiarOr(int vecOr, int _swapCel){
	char cadenaAux[3];
	char cadenaSwap[3];
	
	strcpy(cadenaAux, gci[vecOr].simbolo);
	//printf("1 OK");
	strcpy(cadenaSwap, gci[_swapCel].simbolo);
	//printf("2 OK");
	strcpy(gci[vecOr].simbolo, cadenaSwap);
	//printf("3 OK");
	strcpy(gci[_swapCel].simbolo, cadenaAux);
	//printf("4 OK");
}
void invertirCondicion(int _polOr){
	char *cadena = negarComparador(gci[_polOr].simbolo);
	//printf("valor obtenido: %s", cadena);
	strcpy(gci[_polOr].simbolo, cadena);
}

void crearTabla(){
  file = fopen(TABLA_SIMBOLOS, "w");
  fprintf(file,"%-s\n","NOMBRE                        \t\t\tTIPODATO\t\tVALOR\tLONGITUD");
  fclose(file);
}

char* guardar_cte_int(int valor) {
      char  prefijo[] = "_";
      char constante_string[100];
      sprintf(constante_string,"%d",valor);

      char* nombre_constante = concat(prefijo, constante_string);
      if(existe_simbolo(nombre_constante) == FALSE && cant_elem_ts <= TAM_TABLA){
        strcpy(ts[cant_elem_ts].nombre,nombre_constante);
        ts[cant_elem_ts].longitud = 0;
        strcpy(ts[cant_elem_ts].tipo_dato,"CTE_INTEGER");
        strcpy(ts[cant_elem_ts].valor,constante_string);
        cant_elem_ts++;
      }
      return nombre_constante;
}

void guardar_cte_string(char * valor) {
      char nombre_constante[32];
      /*sprintf(nombre_constante,"_cte_string_%d", contadorCteString);
      char * returnValue = malloc(sizeof(char)*100);
      strcpy(returnValue, nombre_constante);
      if(existe_simbolo(nombre_constante) == FALSE && cant_elem_ts <= TAM_TABLA){
        strcpy(ts[cant_elem_ts].nombre,valor);
        ts[cant_elem_ts].longitud = strlen(valor);
        strcpy(ts[cant_elem_ts].tipo_dato,"CTE_STRING");
        strcpy(ts[cant_elem_ts].valor,valor);
        cant_elem_ts++;
        contadorCteString++;
      }*/
	  //AJUSTE PARA SACAR LOS ESPACIOS POR GUION BAJO
	  strcpy(nombre_constante, valor);
	  char *sust = nombre_constante;
	  int i;
      for(i = 0; i <= strlen(valor)-1; i++) {
	  if(*sust == ' ' || *sust == '.')
		*sust = '_';
		*sust++;
	  }
	  strcpy(ts[cant_elem_ts].nombre,nombre_constante);
      //ts[cant_elem_ts].longitud = strlen(valor);
	  ts[cant_elem_ts].longitud = strlen(valor)-1;
      strcpy(ts[cant_elem_ts].tipo_dato,"CTE_STRING");
      //strcpy(ts[cant_elem_ts].valor,"-");
	  strncpy(ts[cant_elem_ts].valor, valor+1, strlen(valor)-1);
      cant_elem_ts++;
      contadorCteString++;
	  strcpy(const_string_sin_espacio,nombre_constante);
	  //return nombre_constante;

}

char* guardar_cte_float(float valor) {
      
      float constante = valor;
      char  prefijo[] = "_";
      char constante_string[100];
      sprintf(constante_string,"%.2f",constante);
	 
	  
      char* nombre_constante = concat(prefijo, constante_string);
	  /*
	  CODIGO PARA LIMPIAR EL PUNTO QUE TRAE PROBLEMAS EN EL TURBOASSEMBLER
	  */
	  
	  char nombre_constanteFinal[100];
	  strcpy(nombre_constanteFinal,nombre_constante);
	  nombre_constanteFinal[strlen(nombre_constanteFinal)-3] = '_';
	  char* nombre_constanteF = nombre_constanteFinal;
	  
      if(existe_simbolo(nombre_constanteFinal) == FALSE && cant_elem_ts <= TAM_TABLA){
        strcpy(ts[cant_elem_ts].nombre,nombre_constanteFinal);
        ts[cant_elem_ts].longitud = 0;
        strcpy(ts[cant_elem_ts].tipo_dato,"CTE_FLOAT");
        strcpy(ts[cant_elem_ts].valor,constante_string);
        cant_elem_ts++; 
      }
	  
	  
      return nombre_constanteF;
}

void guardar_ts(){
  int i = 0;
  char longitud[3];
  file = fopen(TABLA_SIMBOLOS,"a");
  for(i;i<cant_elem_ts;i++){
    if(ts[i].longitud == 0){
      strcpy(longitud,"-");
	   fprintf(file,"%-30s\t%-s\t%20s\t%-30s\n",ts[i].nombre,ts[i].tipo_dato,ts[i].valor,longitud);
    }
    else{
      sprintf(longitud,"%d",ts[i].longitud);
      //strcpy(longitud,longitud);
	  //strcpy(longitud,ts[i].longitud);
	   fprintf(file,"%-30s\t%-s\t%20s\t%-30s\n",ts[i].nombre,ts[i].tipo_dato,ts[i].valor,longitud);
    }


    //%-35s%-20s%-35s%-5s
  }
  fclose(file);
}

int existe_simbolo(char * comp) {
  char * aux;
  aux = malloc(sizeof(char)*strlen(comp));
  strcpy(aux,comp);
  int i = 0;
  for( i ; i < cant_elem_ts ; i++ ){
    if( strcmp(aux, ts[i].nombre) == 0 ){
      strcpy(simbolo_busqueda.nombre, ts[i].nombre);
      simbolo_busqueda.longitud = ts[i].longitud;
      strcpy(simbolo_busqueda.tipo_dato, ts[i].tipo_dato);
      strcpy(simbolo_busqueda.valor, ts[i].valor);
      free(aux);
      return TRUE;
      }
  }
  free(aux);
  return FALSE;
}

int verificar_asignacion(char * valor) {
  if(!existe_simbolo(valor)){
        return 1;
  } else {
        if(strcmp(ultima_expresion, simbolo_busqueda.tipo_dato) == 0 || (strcmp(simbolo_busqueda.tipo_dato, "real") == 0 && strcmp(ultima_expresion, "integer") == 0)){ //float
              return 2;
        }
        else {
              return 3;
        }
  }
}

char* concat(const char *s1, const char *s2)
{
    const size_t len1 = strlen(s1);
    const size_t len2 = strlen(s2);
    char *result = malloc(len1 + len2 + 1); // +1 for the null-terminator
    // in real code you would check for errors in malloc here
    memcpy(result, s1, len1);
    memcpy(result + len1, s2, len2 + 1); // +1 to copy the null-terminator
    return result;
}

/*Funciones Pila*/
void crearPila(tPila *p)
{
    p->tope = 0;
}

int pilaLlena(tPila *p)
{
    return p->tope == TAM_PILA;
}

int pilaVacia(tPila *p)
{
    return p->tope == 0;
}

int ponerEnPila(tPila *p, int numPolaca)
{
    if(p->tope == TAM_PILA)
        return 0;
    p->numeroPolaca[p->tope] = numPolaca;
    p->tope++;
    return 1;
}

int sacarDePila(tPila *p)
{
    if(p->tope == 0)
        return 0;
     p->tope--;
    int valor =  p->numeroPolaca[p->tope];

    return valor;
}

/* Funciones polaca*/

void crearPolaca(){
  filePolaca = fopen(POLACA, "w");
  crearPila(pila);
  fclose(filePolaca);
}


void insertar_en_polaca_cte_int(int cte, int num){
	char constante_string[32];
	sprintf(constante_string,"_%d",cte);
	strcpy(gci[num].simbolo, constante_string);
	gci[num].numero = num+10;
}

void insertar_en_polaca_cte_real(float cte_real, int num){
	
	char constante_string[100];
    sprintf(constante_string,"_%f",cte_real);
	strcpy(gci[num].simbolo, constante_string);
	gci[num].numero = num+10;
}


void insertar_en_polaca_id(char *valor, int num){
	strcpy(gci[num].simbolo, valor);
	gci[num].numero = num+10;
}


void insertar_en_polaca_operador(char * valor, int num){
	strcpy(gci[num].simbolo, valor);
	gci[num].numero = num+10;
}

char* ObtenerBranchComparador(char* branch){
	
	if(strcmp(branch,">=")==0){	
		strcpy(branch,"BLT"); 	
		
	}	
	if(strcmp(branch,"<=")==0){	
		strcpy(branch,"BGT"); 			
	}	
	if(strcmp(branch,">")==0){		
		strcpy(branch,"BLE"); 	
	}	
	if(strcmp(branch,"<")==0){	
		strcpy(branch,"BGE"); 	
	}	
	if(strcmp(branch,"==")==0){	
		strcpy(branch,"BNE"); 	
	}	
	if(strcmp(branch,"!=")==0){	
		strcpy(branch,"BEQ"); 	
	}	
	return branch;
}



void insertar_en_polaca_salto_condicion(char *simbolo, int num, int negado){	
	char * valorAssembler = ObtenerBranchComparador(simbolo);
	if(negado == 1)
	{
		valorAssembler = negarComparador(simbolo);
	}	
	insertar_en_polaca_operador(valorAssembler, num);	
	insertar_en_polaca_operador(" ", num+1);	
	ponerEnPila(pila, num+1);	
	//printf("apile: %d\n", num+1);	
}

int desapilar_e_insertar_en_celda(int num){
	num += 10;
	char constante_string[32];
	sprintf(constante_string,"%d",num);
	int valor_celda = sacarDePila(pila);
	strcpy(gci[valor_celda].simbolo, constante_string);
	//printf("desapile: %d\n", valor_celda);
	//printf("\n---------------------->!!!!!!!!!!!!aca saco las cosas: (1)%d (2)%d ",num, valor_celda);
	return valor_celda;
}

	void insertar_en_polaca_etiqueta_apilar(int num){
	insertar_en_polaca_operador("ET", num);
	//printf("inserte ET\n");
	ponerEnPila(pila, num);
	//printf("apile: %d\n", num);
}
void insertar_bi_desapilar(int num){
	insertar_en_polaca_operador("BI", num);
	insertar_en_polaca_operador(" ", num+1);
	char constante_string[32];
	int valor_celda = sacarDePila(pila);
	valor_celda += 10;
	sprintf(constante_string,"%d", valor_celda);
	//printf("desapile: %s\n", constante_string);
	strcpy(gci[num+1].simbolo, constante_string);
}

void guardar_gci(int cantidad){
	
  filePolaca = fopen(POLACA,"a");
  int i = 0;
  
  for(i;i< cantidad;i++){

	fprintf(filePolaca,"%s\t",gci[i].simbolo);
  }
  fprintf(filePolaca,"\n",gci[i].simbolo);
  i = 0;
  
    for(i;i< cantidad;i++){
	fprintf(filePolaca,"%d\t",gci[i].numero);
  }
  fclose(filePolaca);
}

char * negarComparador(char* comparador)
{
	if(strcmp(comparador,"BGT") == 0)
		return "BLE";
	if(strcmp(comparador,"BLT") == 0)
		return "BGE";
	if(strcmp(comparador,"BGE") == 0)
		return "BLT";
	if(strcmp(comparador,"BLE") == 0)
		return "BGT";
	if(strcmp(comparador,"BEQ") == 0)
		return "BNE";
	if(strcmp(comparador,"BNE") == 0)
		return "BEQ";
	return NULL;
}
//se realiza ajuste para el or. parametros: celda , valor, celda , valor
void correcionLogicaDelOr(int v1, int c1, int v2, int c2,int flagInvertir)
{
	
	c1 += 10;
	char constante_string[32];
	sprintf(constante_string,"%d",c1);
	int valor_celda = v1;
	strcpy(gci[valor_celda].simbolo, constante_string);
	//printf("\ncorrecion del or, celda %d valor: %d\n",c1, valor_celda);
	if(flagInvertir) {
		c2 += 10;
		char constante_string2[32];
		sprintf(constante_string2,"%d",c2);
		valor_celda = v2;
		strcpy(gci[valor_celda].simbolo, constante_string2);
		//printf("\ncorrecion del or, celda %d valor: %d\n",c2, valor_celda);
	}
	
}

void generaAssembler(int cantidad){
	//printf("La cantidad de elementos en la polaca es: %d",cantidad);
	//guardar_variables_ts();//AGREGO ACA EL GUARDADO DE LA TABLA DE SIMBOLOS ASI INCLUYE LAS VAR AUXI
	crear_pila(&pVariables);
	generarETAssembler();
	generarDataAssembler();
	generarCODEAssembler(cantidad);
	generarETFinAssembler();
}

void generarETAssembler(){
	
  fileAssembler = fopen(ASSEMBLER,"w");
  fprintf(fileAssembler,"INCLUDE macros.asm\nINCLUDE macros2.asm\nINCLUDE number.asm\n.MODEL LARGE\t\t\t;Modelo de Memoria\n.386\t\t\t\t\t;Tipo de Procesador\n.STACK 200h\t\t\t\t;Bytes en el Stack\n\nMAXTEXTSIZE equ 50\n.DATA\n\n");
  fclose(fileAssembler);
}

void generarDataAssembler(){
	
	int i = 0;
	const char ch = '_';
	 fileAssembler = fopen(ASSEMBLER,"a");
	 fprintf(fileAssembler,"@msj\tdb\t\t\"Ingrese valor de la variable: \" ,'$',20 dup(?)\t\t\n");
	 fprintf(fileAssembler,"@auxstr\tdd\t\t?\n");//variable para la carga por teclados
	for(i;i<cant_elem_ts;i++){
		if(strchr(ts[i].nombre,ch) == NULL)
		fprintf(fileAssembler,"%-30s\tdd\t\t?\t\t;Variable de tipo %s\n",ts[i].nombre, ts[i].tipo_dato);
		else{//correccion para completar la tabla de simbolos con los valores necesarios para poder printear
			//fprintf(fileAssembler,"%-30s\tdd\t\t%s\t\t;Constante en formato %s;\n",ts[i].nombre,ts[i].valor,ts[i].tipo_dato);
			
			if(strcmp(ts[i].tipo_dato,"CTE_STRING") == 0)
				fprintf(fileAssembler,"%-30s\tdb\t\t\"%s\" ,'$',%d dup(?)\t\t;Constante en formato %s;\n",ts[i].nombre,ts[i].valor, (50 - ts[i].longitud) , ts[i].tipo_dato);
			else
				fprintf(fileAssembler,"%-30s\tdd\t\t%s\t\t;Constante en formato %s;\n",ts[i].nombre,ts[i].valor,ts[i].tipo_dato);
			}
			
		}
		
	i = 0;
	if(falgCicloEspecial == 1)
		fprintf(fileAssembler,"@auxCE\t \t \t \t\tdd\t\t0.0\t\t;Variable auxiliar para ciclo especial\n");
	if(contVarAux> -1)
		for(i;i<=contVarAux;i++)
			fprintf(fileAssembler,"@aux%-30d\tdd\t\t0.0\t\t;Variable auxiliar\n",i);
	i = 0;
	if(ivecLong > -1)
		for(i;i<=ivecLong;i++)
			fprintf(fileAssembler,"@cte%-30d\tdd\t\t%d\t\t;constante para uso de long\n",vecLong[i],vecLong[i]);
			//fprintf(fileAssembler,"@cte%-30d\tdd\t\t%d\t\t;constante para uso de long\n",vecLong[ivecLong],vecLong[ivecLong]);
	fprintf(fileAssembler,"\n\n");
	fclose(fileAssembler);

}

void generarCODEAssembler(int cantidad){
	
  //int etiquetas[50];
  int cantEtiq = -1;
  char aux1[100];
  char aux2[100];
  fileAssembler = fopen(ASSEMBLER,"a");
  fprintf(fileAssembler,".CODE\nSTART:\nmov AX,@DATA\nmov DS,AX\nmov es,ax;") ;
  fprintf(fileAssembler,"\n\n");
  int in = 0;
  int i = 0;
  //LO QUE TENGO QUE HACER ACA, ES IR RECORRIENDO LA POLACA DESDE EL PRINCIPIO E IR ACUMULANDO EN LOS REGISTROS LOS OPERANDOS, Y CUANDO ENCUENTRO UNA OPERACION DESAPILO..
  //*VOY A ARRANCAR ASI, PRIMERO CON LA SUMA, LUEGO CON LAS CONFICIONES Y POR ULTIMO CON LOS WHILE../*
   //printf("\n::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\n");
   //printf("\n GENERANDO EL CODIGO DE ASSEMBLER\n");
   //printf("\n::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\n");
  for(i;i< cantidad;i++){//printf("........................ indice actual:%d\n",i+10);
	  if(strcmp(gci[i].simbolo,"CMP") == 0){
		//fprintf(fileAssembler," \n;INICIO DE COMPARACION indice: %d\n",i+10);
		//fprintf(fileAssembler,"\n ;COMPARACION\n");
		sacar_de_pila(&pVariables,&aux2);
		sacar_de_pila(&pVariables,&aux1);
		fprintf(fileAssembler, "\n fld %s",aux1);
        fprintf(fileAssembler, "\n fld %s",aux2);
		fprintf(fileAssembler, "\n fxch",aux2);
        fprintf(fileAssembler, "\n fcom");
        fprintf(fileAssembler, "\n fstsw ax");
        fprintf(fileAssembler, "\n sahf\n");
		i++;
		/*char puntSim[10];
		char* puntSim2;
		strcpy(puntSim,gci[i].simbolo);
		puntSim2 = (char*)conversorComparadorAssem(gci[i].simbolo));
		printf("\nACA ESTOY CAMBIANDO EL COMPARADOR: %s\n",puntSim2);*/
		fprintf(fileAssembler,conversorComparadorAssem(gci[i].simbolo));
		i++;
		char auxEqueta[50] = "";
		strcat(auxEqueta,"ETIQUETA_");
		strcat(auxEqueta,gci[i].simbolo);
		if (noExistEtiqueta(cantEtiq,gci[i].simbolo) == 1 ){
			cantEtiq++;
			etiquetas[cantEtiq] = atoi(gci[i].simbolo);
		}
		
		fprintf(fileAssembler, " %s\n",auxEqueta);
		i++; // ESTO ES UNA CORRECCION PORQ YA QUEME TRES LUGARES Y QUEDE PARADO EN EL NUMERO DE LA ETIQUETA, Y PARA QUE NO SE TOME COMO OPERADOR, LO SALTO
		//printf("ACA ESTOY DEJANDO LA ETIQUETA Y ME ENCUENTRO EN EL INDICE %d donde tengo: %s\n",i,gci[i].simbolo);
		//printf("GUARDE EN LA PILA DE ETIQUETAS LS SIGUIENTE: %d\n",etiquetas[cantEtiq]);
		  
	  }
	   if(strcmp(gci[i].simbolo,"BI") == 0){
		  
		//fprintf(fileAssembler," ;SALTO INCONDICIONAL\n");
		//VALIDO SI HAY ETIQUETAS ANTES DE INSERTAR BI, PORQ BI PUEDE SER UNA ETIQUETA
		if(cantEtiq > -1){
			//printf("\n***************************************\n\tVALIDANDO SI HAY ETIQUETAS: %d\n***************************************\n",i+10);
			int comp = i+10;
			int j = 0;
			for(j; j<=cantEtiq; j++){
				//printf("comp: %d",comp);
				if(etiquetas[j] == comp )// || etiquetas[j] == comp) por ahi necesito validar el siguiente
					fprintf(fileAssembler,"\n\n ETIQUETA_%d :",etiquetas[j]);
			}
		}
		i++;
		fprintf(fileAssembler, "\n jmp ETIQUETA_%s\n",gci[i].simbolo);
   		if (noExistEtiqueta(cantEtiq,gci[i].simbolo)== 1 ){
			cantEtiq++;
			etiquetas[cantEtiq] = atoi(gci[i].simbolo);
		}
		//printf("ACA ESTOY DEJANDO LA ETIQUETA Y ME ENCUENTRO EN EL INDICE %d donde tengo: %s\n",i,gci[i].simbolo);
		//printf("GUARDE EN LA PILA DE ETIQUETAS LS SIGUIENTE: %d\n",etiquetas[cantEtiq]);
		  
	  }
	  if(strcmp(gci[i].simbolo,"ET") == 0){
		  
		//fprintf(fileAssembler," \n;INICIO DE WHILE indice: %d\n",i+10);
		//i++;
		char str[30];
		itoa(i+10,str,10);
		//fprintf(fileAssembler, "ETIQUETA_%s\n",str);
   		if (noExistEtiqueta(cantEtiq,str)== 1 ){
			cantEtiq++;
			etiquetas[cantEtiq] = i+10;
		}  
	  }
	   if(strcmp(gci[i].simbolo,"DISPLAY") == 0){
		sacar_de_pila(&pVariables,&aux1);
		//fprintf(fileAssembler,"\n mov ah, 09h");
		//fprintf(fileAssembler,"\n lea dx, %s",aux1);
		//fprintf(fileAssembler,"\n int 21h");
		//SE REEMPLAZA POR LA FUNCION DEL PROFE, tengo que ver que tipo es
		char * paux = aux1;
		printf("--------------------------------------------------valor constante %s\n",aux1);
		if(*paux == '_'){
			fprintf(fileAssembler,"\n newLine 1");
			fprintf(fileAssembler,"\n DisplayString %s,2\n",aux1);
		}
			
		else{
			existe_simbolo(aux1);
			if (strcmp(simbolo_busqueda.tipo_dato, "integer")==0){			
				fprintf(fileAssembler,"\n newLine 1");
				fprintf(fileAssembler,"\n DisplayInteger %s,2\n",aux1);
			}
			else{
					if (strcmp(simbolo_busqueda.tipo_dato, "real")==0){			
						fprintf(fileAssembler,"\n newLine 1");
						fprintf(fileAssembler,"\n DisplayInteger %s,2\n",aux1);
					}
				
				fprintf(fileAssembler,"\n newLine 1");
				fprintf(fileAssembler,"\n DisplayString %s,2\n",aux1);
				
			}
			
		}
			
			

	  }
		if(strcmp(gci[i].simbolo,"GET") == 0){
			sacar_de_pila(&pVariables,&aux1);
			//fprintf(fileAssembler,"\n mov ah, 09h");
			//fprintf(fileAssembler,"\n lea dx, %s",aux1);
			//fprintf(fileAssembler,"\n int 21h");
			//SE REEMPLAZA POR LA FUNCION DEL PROFE, tengo que ver que tipo es
			char * paux = aux1;
			existe_simbolo(aux1);
			printf("--------------------------------------------------valor constante %s\n",aux1);
			if(strcmp(simbolo_busqueda.tipo_dato, "string")==0){
				fprintf(fileAssembler,"\n newLine 1");
				fprintf(fileAssembler,"\n DisplayString @msj,2\n",aux1);
				fprintf(fileAssembler,"\n GetString @auxstr\n");
				fprintf(fileAssembler,"lea si, @auxstr\nlea di, %s\nSTRCPY\n", aux1);

			}
			else{
				existe_simbolo(aux1);
				if (strcmp(simbolo_busqueda.tipo_dato, "integer")==0){
					fprintf(fileAssembler,"\n newLine 1");
					fprintf(fileAssembler,"\n DisplayString @msj,2\n",aux1);
					fprintf(fileAssembler,"\n GetInteger %s\n",aux1);
				}
				else{
					fprintf(fileAssembler,"\n newLine 1");
					fprintf(fileAssembler,"\n DisplayString @msj,2\n",aux1);
					fprintf(fileAssembler,"\n GetFloat %s\n",aux1);
				}



			}
		}
	  
	 if(esOperador(gci[i].simbolo) && strcmp(gci[i].simbolo,":=") != 0){
		 //printf("\nsimbolo encontrado: %s",gci[i].simbolo);
		//fprintf(fileAssembler,"\n fild %s",gci[i].simbolo);
		//DESAPILO OPERANDOS PARA OPERAR
		sacar_de_pila(&pVariables,&aux2);
		sacar_de_pila(&pVariables,&aux1);
		fprintf(fileAssembler,"\n fld %s",aux1);
		fprintf(fileAssembler,"\n fld %s",aux2);
		if (strcmp(gci[i].simbolo, "+") == 0)
		{//fprintf(fileAssembler,"\n es mas");
			//fprintf(fileAssembler,"\t;\nSUMA\n");
			fprintf(fileAssembler,"\n fadd\t;SUMA\n");
			char auxStr[50] = "";
			sprintf(auxStr, "@aux%d",in);
			fprintf(fileAssembler, " fstp %s ;ASIGNACION\n\n",auxStr);
			//insertarTokenEnTS("",auxStr);
			poner_en_pila(&pVariables,&auxStr);
			in++;
		}
			
		if (strcmp(gci[i].simbolo, "-") == 0)
		{//fprintf(fileAssembler,"\n es menos");
			//fprintf(fileAssembler,"\t;\nRESTA\n");
			fprintf(fileAssembler,"\n fsub\t;RESTA\n");
			char auxStr[50] = "";
			sprintf(auxStr, "@aux%d",in);
			fprintf(fileAssembler, " fstp %s;ASIGNACION\n\n",auxStr);
			//insertarTokenEnTS("",auxStr);
			poner_en_pila(&pVariables,&auxStr);
			in++;
		}
			
		if (strcmp(gci[i].simbolo, "*") == 0)
		{//fprintf(fileAssembler,"\n es multiplicacion");
			//fprintf(fileAssembler,"\t;\nMULTIPLICACION\n");
			fprintf(fileAssembler," \n fmul\t;MULTIPLICACION\n");
			char auxStr[50] = "";
			sprintf(auxStr, "@aux%d",in);
			fprintf(fileAssembler, " fstp %s;ASIGNACION\n\n",auxStr);
			//insertarTokenEnTS("",auxStr);
			poner_en_pila(&pVariables,&auxStr);
			in++;
		}
			
		if (strcmp(gci[i].simbolo, "/") == 0)
		{//fprintf(fileAssembler,"\n es division");
			//fprintf(fileAssembler,"\t;\nDIVISION\n");
			fprintf(fileAssembler,"\n fdiv\t;DIVISION\n");
			char auxStr[50] = "";
			sprintf(auxStr, "@aux%d",in);
			fprintf(fileAssembler, " fstp %s;ASIGNACION\n\n",auxStr);
			//insertarTokenEnTS("",auxStr);
			poner_en_pila(&pVariables,&auxStr);
			in++;
		}
			
	 }
	 if(!esOperador(gci[i].simbolo) && strcmp(gci[i].simbolo,":=") != 0 && strcmp(gci[i+1].simbolo,":=") != 0)
	    { 
		//fprintf(fileAssembler,"\n es operando");
	 //ponerEnPila_assembler(pila_assembler, 1); printf("apilo con assembler");}
		//fprintf(fileAssembler,"\n fild %s",gci[i].simbolo);
		//ponerEnPila(gci[i].simbolo);
		char auxNombre[50] = "";
		strcpy(auxNombre, gci[i].simbolo);
		poner_en_pila(&pVariables,&auxNombre);
		
		}
		if(!esOperador(gci[i].simbolo) && strcmp(gci[i].simbolo,":=") != 0 && strcmp(gci[i+1].simbolo,":=") == 0){ 
		//fprintf(fileAssembler,"\n operador antes de asignacion");
	 //ponerEnPila_assembler(pila_assembler, 1); printf("apilo con assembler");}
	    //fprintf(fileAssembler," ;ASGINACION\n");
		tope_pila(&pVariables,&aux1);
		//printf("antes de asingar: tope de pila:%s\n",aux1);	
// NO SSTOY SEGURO SI ES NECESARIO SCAR ESTO DE LA PILA, VI QUE NO PASA NADA SI LO SACO, PERO NO SE		
		//sacar_de_pila(&pVariables,&aux2);
		//sacar_de_pila(&pVariables,&aux1);
		//printf("------------------------------------------------id: %d----------------ACA: %s  - %s\n",i+10,gci[i].simbolo,gci[i-1].simbolo);
		existe_simbolo(gci[i].simbolo);
		if (strcmp(simbolo_busqueda.tipo_dato, "string")==0){
			//sacar_de_pila(&pVariables,&aux2);
			fprintf(fileAssembler,"\n lea si, %s",gci[i-1].simbolo);
			fprintf(fileAssembler,"\n lea di, %s",gci[i].simbolo);
			fprintf(fileAssembler,"\n STRCPY;ASIGNACION\n\n");
		}
		else{
			fprintf(fileAssembler,"\n fld %s",aux1);
			fprintf(fileAssembler,"\n fstp %s;ASIGNACION\n\n",gci[i].simbolo);
		}
		
		//fprintf(fileAssembler,"\n ffree");
		//tope_pila(&pVariables,&aux1);
		//printf("despues de asingar: tope de pila:%s\n",aux1);
		if(strcmp(gci[i].simbolo,"@auxCE") == 0)
		{//printf("guardando el aux para ciclo especial par ala comparacion:%s\n",gci[i].simbolo);
			poner_en_pila(&pVariables,gci[i].simbolo);
		}
		i ++;
		//printf("lo siguiente que viene en la polaca es: %s\n",gci[i].simbolo);
		}
		
		if(cantEtiq > -1){
			//printf("\n***************************************\n\tVALIDANDO SI HAY ETIQUETAS: %d\n***************************************\n",i+10);
			int comp = i+10;
			int j = 0;
			for(j; j<=cantEtiq; j++){
				//printf("comp: %d",comp);
				if(etiquetas[j] == comp )// || etiquetas[j] == comp) por ahi necesito validar el siguiente
					fprintf(fileAssembler,"\n\n ETIQUETA_%d :",etiquetas[j]);
			}
		}
	}
	//printf("........................ indice actual:%d",i+10);
	char str[30];
	itoa(i+10,str,10);
	if (noExistEtiqueta(cantEtiq,str)== 0 ){
			fprintf(fileAssembler,"\n\n ETIQUETA_%d :",i+10);
		}
  fprintf(fileAssembler,"\n\n");
  fclose(fileAssembler);
    printf("\nCODIGO TRADUCIDO A ASSEMBLER EXITOSAMENTE\n");
}

void generarETFinAssembler(){
	
  fileAssembler = fopen(ASSEMBLER,"a");
  fprintf(fileAssembler,"mov ax,4c00h\t\t\t;Indica que debe finalizar la ejecucion\n");
  fprintf(fileAssembler,"int 21h\n\nEND START");
  fclose(fileAssembler);
}

//podriamos usar esta funcion para identificar si es una operador
int esOperador(char *simbolo){
		//return strcmp(simbolo, "+");
		if (strcmp(simbolo, "+") == 0)
			return 1;
		if (strcmp(simbolo, "-") == 0)
			return 1;
		if (strcmp(simbolo, "*") == 0)
			return 1;
		if (strcmp(simbolo, "/") == 0)
			return 1;
		return 0;
		
}

char* conversorComparadorAssem(char* comparador)
{

	if(strcmp(comparador,"BGT") == 0)
		return " JA";
	if(strcmp(comparador,"BLT") == 0)
		return " JB";
	if(strcmp(comparador,"BGE") == 0)
		return " JAE";
	if(strcmp(comparador,"BLE") == 0)
		return " JNA";
	if(strcmp(comparador,"BEQ") == 0)
		return " JE";
	if(strcmp(comparador,"BNE") == 0)
		return " JNE";
	return NULL;
}
int noExistEtiqueta(int cantEtiq,char* simbolo)
{
	int noExiste = 1;
	int simbo = atoi(simbolo);
	int i = 0;
	if (cantEtiq == -1)
		return 1;
	for ( i; i <= cantEtiq; i++)
		if(etiquetas[i] == simbo)
			noExiste = 0;
	return noExiste;
}
