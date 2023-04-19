/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 27 "parser.y"

    #include <bits/stdc++.h>
    #include "SymbolTable.cpp"
    #include "SymbolEntry.cpp"
    #include "AST.h"

#line 56 "parser.tab.h"

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    UNDERSCORE = 258,              /* UNDERSCORE  */
    PACKAGE = 259,                 /* PACKAGE  */
    GOTO = 260,                    /* GOTO  */
    IMPLEMENTS = 261,              /* IMPLEMENTS  */
    DECIMAL_INTEGER = 262,         /* DECIMAL_INTEGER  */
    HEX_INTEGER = 263,             /* HEX_INTEGER  */
    OCTAL_INTEGER = 264,           /* OCTAL_INTEGER  */
    BINARY_INTEGER = 265,          /* BINARY_INTEGER  */
    DECIMAL_FLOATING = 266,        /* DECIMAL_FLOATING  */
    HEXADECIMAL_FLOATING = 267,    /* HEXADECIMAL_FLOATING  */
    AT = 268,                      /* AT  */
    PROTECTED = 269,               /* PROTECTED  */
    PRIVATE = 270,                 /* PRIVATE  */
    ABSTRACT = 271,                /* ABSTRACT  */
    ELLIPSIS = 272,                /* ELLIPSIS  */
    COMMA = 273,                   /* COMMA  */
    OPERATOR = 274,                /* OPERATOR  */
    SEPARATOR = 275,               /* SEPARATOR  */
    IDENTIFIER = 276,              /* IDENTIFIER  */
    CURLYBRACESTART = 277,         /* CURLYBRACESTART  */
    CURLYBRACEEND = 278,           /* CURLYBRACEEND  */
    VAR = 279,                     /* VAR  */
    SEMICOLON = 280,               /* SEMICOLON  */
    BRACESTART = 281,              /* BRACESTART  */
    ELSE = 282,                    /* ELSE  */
    CATCH = 283,                   /* CATCH  */
    IF = 284,                      /* IF  */
    PERIOD = 285,                  /* PERIOD  */
    QUESTION = 286,                /* QUESTION  */
    AND = 287,                     /* AND  */
    XOR = 288,                     /* XOR  */
    LESSER = 289,                  /* LESSER  */
    THIS = 290,                    /* THIS  */
    CLASS = 291,                   /* CLASS  */
    BOOLEAN = 292,                 /* BOOLEAN  */
    VOID = 293,                    /* VOID  */
    NEW = 294,                     /* NEW  */
    EQUAL = 295,                   /* EQUAL  */
    LITERAL = 296,                 /* LITERAL  */
    STRING = 297,                  /* STRING  */
    INSTANCEOF = 298,              /* INSTANCEOF  */
    BYTE = 299,                    /* BYTE  */
    SHORT = 300,                   /* SHORT  */
    INT = 301,                     /* INT  */
    LONG = 302,                    /* LONG  */
    CHAR = 303,                    /* CHAR  */
    FLOAT = 304,                   /* FLOAT  */
    DOUBLE = 305,                  /* DOUBLE  */
    DEC = 306,                     /* DEC  */
    INC = 307,                     /* INC  */
    NOT = 308,                     /* NOT  */
    TILDE = 309,                   /* TILDE  */
    ADD = 310,                     /* ADD  */
    SUB = 311,                     /* SUB  */
    MUL = 312,                     /* MUL  */
    DIV = 313,                     /* DIV  */
    MOD = 314,                     /* MOD  */
    LSHIFT = 315,                  /* LSHIFT  */
    RSHIFT = 316,                  /* RSHIFT  */
    URSHIFT = 317,                 /* URSHIFT  */
    LSHIFT_ASSIGN = 318,           /* LSHIFT_ASSIGN  */
    RSHIFT_ASSIGN = 319,           /* RSHIFT_ASSIGN  */
    NEQ = 320,                     /* NEQ  */
    EQ = 321,                      /* EQ  */
    ASSIGN = 322,                  /* ASSIGN  */
    MUL_ASSIGN = 323,              /* MUL_ASSIGN  */
    DIV_ASSIGN = 324,              /* DIV_ASSIGN  */
    MOD_ASSIGN = 325,              /* MOD_ASSIGN  */
    ADD_ASSIGN = 326,              /* ADD_ASSIGN  */
    SUB_ASSIGN = 327,              /* SUB_ASSIGN  */
    LEQ = 328,                     /* LEQ  */
    GEQ = 329,                     /* GEQ  */
    URSHIFT_ASSIGN = 330,          /* URSHIFT_ASSIGN  */
    AND_ASSIGN = 331,              /* AND_ASSIGN  */
    XOR_ASSIGN = 332,              /* XOR_ASSIGN  */
    OR_ASSIGN = 333,               /* OR_ASSIGN  */
    SCOPE = 334,                   /* SCOPE  */
    EXTENDS = 335,                 /* EXTENDS  */
    TRY = 336,                     /* TRY  */
    DEFAULT = 337,                 /* DEFAULT  */
    BRACEEND = 338,                /* BRACEEND  */
    WHILE = 339,                   /* WHILE  */
    SWITCH = 340,                  /* SWITCH  */
    DO = 341,                      /* DO  */
    FOR = 342,                     /* FOR  */
    OR = 343,                      /* OR  */
    COLON = 344,                   /* COLON  */
    RETURN = 345,                  /* RETURN  */
    THROW = 346,                   /* THROW  */
    SYNCHRONIZED = 347,            /* SYNCHRONIZED  */
    FINALLY = 348,                 /* FINALLY  */
    BREAK = 349,                   /* BREAK  */
    CONTINUE = 350,                /* CONTINUE  */
    PTR = 351,                     /* PTR  */
    GREATER = 352,                 /* GREATER  */
    ASSERT = 353,                  /* ASSERT  */
    SQUAREBRACESTART = 354,        /* SQUAREBRACESTART  */
    SQUAREBRACEEND = 355,          /* SQUAREBRACEEND  */
    AND_AND = 356,                 /* AND_AND  */
    OR_OR = 357,                   /* OR_OR  */
    YIELD = 358,                   /* YIELD  */
    TRANSITIVE = 359,              /* TRANSITIVE  */
    RECORD = 360,                  /* RECORD  */
    OPEN = 361,                    /* OPEN  */
    WITH = 362,                    /* WITH  */
    TO = 363,                      /* TO  */
    PROVIDES = 364,                /* PROVIDES  */
    NON_SEALED = 365,              /* NON_SEALED  */
    SEALED = 366,                  /* SEALED  */
    PERMITS = 367,                 /* PERMITS  */
    MODULE = 368,                  /* MODULE  */
    USES = 369,                    /* USES  */
    REQUIRES = 370,                /* REQUIRES  */
    OPENS = 371,                   /* OPENS  */
    EXPORTS = 372,                 /* EXPORTS  */
    SUPER = 373,                   /* SUPER  */
    NATIVE = 374,                  /* NATIVE  */
    CONST = 375,                   /* CONST  */
    VOLATILE = 376,                /* VOLATILE  */
    STRICTFP = 377,                /* STRICTFP  */
    STATIC = 378,                  /* STATIC  */
    INTERFACE = 379,               /* INTERFACE  */
    FINAL = 380,                   /* FINAL  */
    TRANSIENT = 381,               /* TRANSIENT  */
    ENUM = 382,                    /* ENUM  */
    CASE = 383,                    /* CASE  */
    THROWS = 384,                  /* THROWS  */
    PUBLIC = 385,                  /* PUBLIC  */
    IMPORT = 386                   /* IMPORT  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 34 "parser.y"

    Node* node;
    char* val;

#line 209 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
