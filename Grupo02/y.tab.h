
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
     COMPARADOR = 277,
     IF = 278,
     THEN = 279,
     ELSE = 280,
     ENDIF = 281,
     DIM = 282,
     CORA = 283,
     CORC = 284,
     AS = 285,
     TIPO = 286,
     COMA = 287,
     LONG = 288,
     IN = 289,
     DO = 290,
     ENDWHILE = 291,
     CTE_R = 292,
     NOT = 293
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
#define COMPARADOR 277
#define IF 278
#define THEN 279
#define ELSE 280
#define ENDIF 281
#define DIM 282
#define CORA 283
#define CORC 284
#define AS 285
#define TIPO 286
#define COMA 287
#define LONG 288
#define IN 289
#define DO 290
#define ENDWHILE 291
#define CTE_R 292
#define NOT 293




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 20 "Sintactico.y"
 
    int intValue; 
    float floatValue; 
    char *stringValue; 



/* Line 1676 of yacc.c  */
#line 136 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


