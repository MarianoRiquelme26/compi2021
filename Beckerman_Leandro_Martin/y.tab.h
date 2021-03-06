
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ID = 258,
     OP_ASIG = 259,
     CTE = 260,
     COMEN = 261,
     DISPLAY = 262,
     CTE_S = 263,
     ENTER = 264,
     OP_SUM = 265,
     OP_RES = 266,
     OP_MUL = 267,
     OP_DIV = 268,
     PARA = 269,
     PARC = 270,
     GET = 271,
     WHILE = 272,
     START = 273,
     END = 274,
     OR = 275,
     AND = 276,
     OP_MAYOR = 277,
     OP_MAYORIGUAL = 278,
     OP_MENORIGUAL = 279,
     OP_IGUAL = 280,
     OP_MENOR = 281,
     OP_DISTINTO = 282,
     IF = 283,
     THEN = 284,
     ELSE = 285,
     ENDIF = 286,
     DIM = 287,
     CORA = 288,
     CORC = 289,
     AS = 290,
     TIPO = 291,
     COMA = 292,
     LONG = 293,
     IN = 294,
     DO = 295,
     ENDWHILE = 296,
     CTE_R = 297,
     NOT = 298
   };
#endif
/* Tokens.  */
#define ID 258
#define OP_ASIG 259
#define CTE 260
#define COMEN 261
#define DISPLAY 262
#define CTE_S 263
#define ENTER 264
#define OP_SUM 265
#define OP_RES 266
#define OP_MUL 267
#define OP_DIV 268
#define PARA 269
#define PARC 270
#define GET 271
#define WHILE 272
#define START 273
#define END 274
#define OR 275
#define AND 276
#define OP_MAYOR 277
#define OP_MAYORIGUAL 278
#define OP_MENORIGUAL 279
#define OP_IGUAL 280
#define OP_MENOR 281
#define OP_DISTINTO 282
#define IF 283
#define THEN 284
#define ELSE 285
#define ENDIF 286
#define DIM 287
#define CORA 288
#define CORC 289
#define AS 290
#define TIPO 291
#define COMA 292
#define LONG 293
#define IN 294
#define DO 295
#define ENDWHILE 296
#define CTE_R 297
#define NOT 298




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 21 "Sintactico.y"
 
    int intValue; 
    float floatValue; 
    char *stringValue; 



/* Line 1676 of yacc.c  */
#line 146 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


