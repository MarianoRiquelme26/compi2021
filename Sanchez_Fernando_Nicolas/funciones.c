#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>
#include "array.c"

#define INITIAL_CAPACITY 1
#define MAX_STRING_LENGTH 30
#define TABLA_SIMBOLOS "ts.txt"
#define POLACA "intermedia.txt"
#define TAM_TABLA 350
#define TAM_POLACA 350
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

//funciones polaca inversa
void crearPolaca();
void insertar_en_polaca_cte_int(int cte, int num);
void insertar_en_polaca_cte_real(float cte_real, int num);
void insertar_en_polaca_id(char *valor, int num);
void insertar_en_polaca_operador(char * valor, int num);
void guardar_gci(int cantidad);

//funciones complementarias
char* concat(const char *s1, const char *s2);

typedef struct {
	char nombre[TAM_NOMBRE];
	char tipo_dato[TAM_NOMBRE];
	char valor[TAM_NOMBRE];
	int longitud;
} simbolo;

simbolo ts[TAM_TABLA];
simbolo simbolo_busqueda;

typedef struct {
	char simbolo[TAM_NOMBRE];
	int numero;
} polaca;

polaca gci[TAM_POLACA];

FILE * file;
FILE * filePolaca;
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

void guardar_variables_ts(){
  int i = 0;
  for(i; i<array_nombres_variables.used; i++){
    if(cant_elem_ts<=TAM_TABLA && !existe_simbolo(array_nombres_variables.array[i])){
      strcpy(ts[cant_elem_ts].nombre,array_nombres_variables.array[i]);
      ts[cant_elem_ts].longitud = 0;
      strcpy(ts[cant_elem_ts].tipo_dato,array_tipos_variables.array[i]);
      strcpy(ts[cant_elem_ts].valor,"-");
      cant_elem_ts++;
    }
    else{
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

void crearTabla(){
  file = fopen(TABLA_SIMBOLOS, "w");
  fprintf(file,"%-s\n","NOMBRE                        \tTIPODATO\t\tVALOR\tLONGITUD");
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
	  strcpy(ts[cant_elem_ts].nombre,valor);
      ts[cant_elem_ts].longitud = strlen(valor);
      strcpy(ts[cant_elem_ts].tipo_dato,"CTE_STRING");
      strcpy(ts[cant_elem_ts].valor,"-");
      cant_elem_ts++;
      contadorCteString++;
	  

}

char* guardar_cte_float(float valor) {
      
      float constante = valor;
      char  prefijo[] = "_";
      char constante_string[100];
      sprintf(constante_string,"%f",constante);
      char* nombre_constante = concat(prefijo, constante_string);
      if(existe_simbolo(nombre_constante) == FALSE && cant_elem_ts <= TAM_TABLA){
        strcpy(ts[cant_elem_ts].nombre,nombre_constante);
        ts[cant_elem_ts].longitud = 0;
        strcpy(ts[cant_elem_ts].tipo_dato,"CTE_FLOAT");
        strcpy(ts[cant_elem_ts].valor,constante_string);
        cant_elem_ts++; 
      }
      return nombre_constante;
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
        if(strcmp(ultima_expresion, simbolo_busqueda.tipo_dato) == 0 || (strcmp(simbolo_busqueda.tipo_dato, "real") == 0 && strcmp(ultima_expresion, "int") == 0)){ //float
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
/* Funciones polaca*/

void crearPolaca(){
  filePolaca = fopen(POLACA, "w");
  fclose(filePolaca);
}


void insertar_en_polaca_cte_int(int cte, int num){
	char constante_string[32];
	sprintf(constante_string,"%d",cte);
	strcpy(gci[num].simbolo, constante_string);
	gci[num].numero = num+10;
}

void insertar_en_polaca_cte_real(float cte_real, int num){
	
	char constante_string[100];
    sprintf(constante_string,"%f",cte_real);
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